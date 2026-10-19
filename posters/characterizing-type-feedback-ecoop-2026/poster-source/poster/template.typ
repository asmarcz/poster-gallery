/*
Template by Oliver Tušla, asmarcz, 2026.
*/

#let template(
  authors-size: auto,
  column-width-section: true,
  body-size: 32pt,
  corner-radius: 0pt,
  list-spacing: 0.65em,
  section-sep-size: 1.5em,
  section-inset: 0.5em,
  section-border: 3pt,
  title-size: auto,
  page-fill: luma(95%),
  page-margin: 25mm,
  par-leading: 0.65em,
) = {
  let title-size = if title-size == auto { 1.6 * body-size } else { title-size }
  let authors-size = if authors-size == auto { 0.8 * body-size } else { authors-size }

  let config = (
    authors-size: authors-size,
    column-width-section: column-width-section,
    body-size: body-size,
    corner-radius: corner-radius,
    list-spacing: list-spacing,
    section-sep-size: section-sep-size,
    section-inset: section-inset,
    section-border: section-border,
    title-size: title-size,
    page-fill: page-fill,
    page-margin: page-margin,
    par-leading: par-leading,
  )

  let section-sep() = v(section-sep-size, weak: true)

  let section-content(body, height: auto, width-override: none) = {
    set par(spacing: 0pt)
    block(
      fill: white,
      stroke: luma(10%) + section-border,
      inset: section-inset,
      radius: (bottom-left: corner-radius, bottom-right: corner-radius),
      height: height,
      width: if width-override == none {
        if (column-width-section) { 100% } else { auto }
      } else { width-override },
    )[
      #set par(spacing: 1.05em)
      #body
    ]
  }

  let section(title, body, title-align: start, height: auto, width-override: none, lift-to-baseline: false) = {
    set par(spacing: 0pt)
    let inner = {
      align(title-align, block(
        fill: white,
        stroke: (rest: luma(10%) + section-border, bottom: none),
        inset: section-inset,
        radius: (top-left: corner-radius, top-right: corner-radius),
        heading(level: 2, title),
      ))
      section-content(body, height: height, width-override: width-override)
    }
    if lift-to-baseline {
      pad(section-inset, inner)
    } else {
      inner
    }
  }

  let title-block(title, authors) = section-content({
    box(width: 100%, {
      set align(center)
      heading()[
        #set text(size: title-size, weight: "medium")
        #title
      ]
      set text(size: authors-size)
      v(0.5em)

      set align(center)
      authors
        .map(a => box[
          #a.name \
          #text(size: 0.8em, link("mailto:" + a.email, raw(a.email)))
        ])
        .join(h(1em))
    })
  })

  let poster(title: none, authors: (), body) = {
    set document(author: authors.map(a => a.name), title: title)
    set page(
      margin: page-margin, // default 10 cm for A0
      paper: "a0",
      fill: page-fill,
    )
    set par(justify: true, leading: par-leading)
    set list(spacing: list-spacing)

    show heading: set text(font: "IBM Plex Serif")
    set text(
      font: "IBM Plex Sans",
      size: body-size,
    )

    body
  }

  (
    poster: poster,
    section: section,
    section-auto: section.with(width-override: auto),
    section-auto-end: section.with(title-align: end, width-override: auto),
    section-content: section-content,
    section-sep: section-sep,
    title-block: title-block,
    config: config,
  )
}
