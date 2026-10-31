// Builds every CV variant in cv/variants/ to build/cv/<variant>.pdf, and copies
// the academic default to build/cv/cv_siepe.pdf (the URL the site serves).
//
// Usage: node scripts/build-cv.mjs   (or: npm run cv)
// The typst binary is taken from $TYPST, else from PATH.
// The printed build date is today, or $CV_DATE (YYYY-MM-DD) for reproducible builds.

import { execFileSync } from "node:child_process";
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
const typst = process.env.TYPST || "typst";
const date = process.env.CV_DATE || new Date().toISOString().slice(0, 10);
const outDir = path.join(root, "build", "cv");
fs.mkdirSync(outDir, { recursive: true });

const variants = fs.readdirSync(path.join(root, "cv", "variants")).filter((f) => f.endsWith(".typ"));
for (const v of variants) {
  const out = path.join(outDir, v.replace(/\.typ$/, ".pdf"));
  try {
    execFileSync(typst, [
      "compile", "--root", root, "--font-path", path.join(root, "fonts"), "--ignore-system-fonts",
      "--input", `date=${date}`, path.join(root, "cv", "variants", v), out,
    ], { stdio: "inherit" });
  } catch (e) {
    if (e.code === "ENOENT") {
      console.error(`Typst not found ("${typst}"). Install it, make sure it is on PATH (restart the editor after installing), or set TYPST to the full path of the typst executable.`);
      process.exit(1);
    }
    throw e;
  }
  console.log(`built ${path.relative(root, out)}`);
}
fs.copyFileSync(path.join(outDir, "academic.pdf"), path.join(outDir, "cv_siepe.pdf"));
console.log("built build/cv/cv_siepe.pdf (academic)");
