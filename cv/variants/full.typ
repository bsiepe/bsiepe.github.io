// Full CV: every section, school, all community service, training, and media.
#import "../lib/cv.typ": cv, academic-sections
#cv(
  title: "Curriculum Vitae (full)",
  sections: academic-sections + ("media", "training"),
  school: true,
  community-from: 0,
)
