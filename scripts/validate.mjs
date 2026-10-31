// Validates every file in data/ against schema/.
// Usage: node scripts/validate.mjs   (or: npm run validate)
// Exits non-zero on any error.
//
// Checks: JSON Schema (required fields, date and DOI formats, area tags,
// unknown fields), unquoted dates, duplicate ids, references to ids in other
// files, and that every `file` / `thumbnail` / `photo` path exists.

import Ajv2020 from "ajv/dist/2020.js";
import addFormats from "ajv-formats";
import YAML from "yaml";
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
const schemaDir = path.join(root, "schema");
const dataDir = path.join(root, "data");

// strictRequired is off because conditional `then: { required: [...] }` blocks
// name properties defined in the enclosing schema, which strict mode rejects.
const ajv = new Ajv2020({ allErrors: true, strict: true, strictRequired: false });
addFormats(ajv);
for (const f of fs.readdirSync(schemaDir).filter((f) => f.endsWith(".schema.json"))) {
  ajv.addSchema(JSON.parse(fs.readFileSync(path.join(schemaDir, f), "utf8")));
}

const errors = [];
const err = (file, where, msg) => errors.push(`${file}${where ? " " + where : ""}: ${msg}`);

// YAML 1.1 turns unquoted dates into Date objects, so the schema's
// `type: string` rejects them. That enforces quoting.
const data = {};
for (const f of fs.readdirSync(dataDir).filter((f) => f.endsWith(".yml")).sort()) {
  const name = f.replace(/\.yml$/, "");
  const validate = ajv.getSchema(`${name}.schema.json`);
  if (!validate) { err(f, "", `no schema/${name}.schema.json`); continue; }
  let doc;
  try {
    doc = YAML.parse(fs.readFileSync(path.join(dataDir, f), "utf8"), { schema: "yaml-1.1", uniqueKeys: true });
  } catch (e) { err(f, "", `YAML error: ${e.message}`); continue; }
  if (!validate(doc)) {
    for (const e of validate.errors) err(f, e.instancePath || "/", `${e.message}${e.params?.additionalProperty ? ` (${e.params.additionalProperty})` : ""}`);
  }
  data[name] = doc;
}

// Duplicate ids within each file.
const ids = {};
for (const [name, doc] of Object.entries(data)) {
  if (!Array.isArray(doc)) continue;
  ids[name] = new Set();
  doc.forEach((entry, i) => {
    if (!entry?.id) return;
    if (ids[name].has(entry.id)) err(`${name}.yml`, `/${i}`, `duplicate id "${entry.id}"`);
    ids[name].add(entry.id);
  });
}

// Cross-file references.
const allIds = new Set(Object.values(ids).flatMap((s) => [...s]));
const checkRefs = (name, field, pool, poolName) => {
  (Array.isArray(data[name]) ? data[name] : []).forEach((entry, i) => {
    for (const ref of entry?.[field] ?? []) {
      if (!pool.has(ref)) err(`${name}.yml`, `/${i}/${field}`, `unknown ${poolName} id "${ref}"`);
    }
  });
};
const pubIds = ids.publications ?? new Set();
if (data.publications) {
  checkRefs("talks", "publications", pubIds, "publication");
  checkRefs("software", "publications", pubIds, "publication");
}
checkRefs("awards", "related", allIds, "entry");
checkRefs("media", "about", allIds, "entry");

// Shared-authorship positions must point at existing authors.
(data.publications ?? []).forEach((p, i) => {
  for (const key of ["shared_first", "shared_second"]) {
    for (const pos of p[key] ?? []) {
      if (pos > (p.authors?.length ?? 0)) err("publications.yml", `/${i}/${key}`, `position ${pos} exceeds author count`);
    }
  }
  if (!(p.authors ?? []).some((a) => a.me)) err("publications.yml", `/${i}/authors`, "no author marked me: true");
});

// File paths must exist.
const checkPath = (file, where, p) => {
  if (p && !fs.existsSync(path.join(root, p))) err(file, where, `file not found: ${p}`);
};
for (const name of ["talks", "workshops"]) {
  (data[name] ?? []).forEach((entry, i) => {
    checkPath(`${name}.yml`, `/${i}/thumbnail`, entry.thumbnail);
    (entry.events ?? entry.sessions ?? []).forEach((ev, j) => checkPath(`${name}.yml`, `/${i}/${entry.events ? "events" : "sessions"}/${j}/file`, ev.file));
  });
}
if (data.profile) {
  checkPath("profile.yml", "/photo", data.profile.photo);
  checkPath("profile.yml", "/social_image", data.profile.social_image);
}

const files = Object.keys(data).length;
if (errors.length) {
  console.error(errors.join("\n"));
  console.error(`\n${errors.length} error(s) in ${files} file(s).`);
  process.exit(1);
}
console.log(`data/ is valid (${files} file(s)).`);
