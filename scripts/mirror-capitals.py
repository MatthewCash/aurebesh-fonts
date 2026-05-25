import fontforge


font = fontforge.open("fonts/AurebeshAF-Legends.otf")


def mirror_glyph(glyph):
    width = glyph.width
    glyph.transform((-1, 0, 0, 1, width, 0))
    glyph.width = width


for codepoint in range(ord("A"), ord("Z") + 1):
    mirror_glyph(font[codepoint])

for glyph in list(font.glyphs()):
    ligatures = [sub for sub in glyph.getPosSub("*") if sub[1] == "Ligature"]
    uppercase_ligatures = [sub for sub in ligatures if sub[2][0].isupper()]

    if not uppercase_ligatures:
        continue

    backward_name = glyph.glyphname + ".backwards"
    backward_glyph = font.createChar(-1, backward_name)

    font.selection.none()
    font.selection.select(glyph.glyphname)
    font.copy()
    font.selection.none()
    font.selection.select(backward_name)
    font.paste()

    mirror_glyph(backward_glyph)

    for subtable in {sub[0] for sub in ligatures}:
        glyph.removePosSub(subtable)

    for sub in ligatures:
        target = backward_glyph if sub in uppercase_ligatures else glyph
        target.addPosSub(sub[0], sub[2:])

font.familyname = "Aurebesh"
font.fullname = "Aurebesh"
font.fontname = "Aurebesh"
font.generate("aurebesh.otf")
