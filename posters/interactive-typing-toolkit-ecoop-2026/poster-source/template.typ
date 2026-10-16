/*
Template by Oliver Tušla, asmarcz, 2026.
*/

#let template(
  column-width-section: true,
  columns-gutter-add: 0mm,
  body-size: 32pt,
  list-spacing: 0.65em,
  section-sep-size: 1.5em,
  section-inset: 0.5em,
  section-border: 3pt,
  title-size: auto,
  page-margin: 25mm,
  par-leading: 0.65em,
) = {
  let title-size = if title-size == auto { 1.6 * body-size } else { title-size }
  let authors-size = body-size

  let config = (
    column-width-section: column-width-section,
    columns-gutter-add: columns-gutter-add,
    body-size: body-size,
    list-spacing: list-spacing,
    section-sep-size: section-sep-size,
    section-inset: section-inset,
    section-border: section-border,
    title-size: title-size,
    page-margin: page-margin,
    par-leading: par-leading,
    authors-size: authors-size,
  )

  let section-sep() = v(section-sep-size, weak: true)

  let section-content(body) = {
    set par(spacing: 0pt)
    block(
      fill: white,
      stroke: luma(10%) + section-border,
      inset: section-inset,
      width: if (column-width-section) { 100% } else { auto },
    )[
      #set par(spacing: 1.05em)
      #body
    ]
  }

  let section(title, body) = {
    set par(spacing: 0pt)
    block(
      fill: white,
      stroke: (rest: luma(10%) + section-border, bottom: none),
      inset: section-inset,
      heading(level: 2, title),
    )
    section-content(body)
  }

  let poster(title: none, authors: (), full-width-title: false, body) = {
    set document(author: authors.map(a => a.name), title: title)
    set page(
      columns: 2,
      margin: page-margin, // default 10 cm for A0
      paper: "a0",
      fill: luma(95%),
    )
    // 2 * section-inset == 1em == body-size at this text size, so keep it absolute
    let columns-gutter = page-margin - body-size - 2 * section-border + columns-gutter-add
    set columns(gutter: if columns-gutter > 0pt { columns-gutter } else { 0pt })
    set par(justify: true, leading: par-leading)
    set list(spacing: list-spacing)

    show heading: set text(font: "IBM Plex Serif")
    set text(
      font: "IBM Plex Sans",
      size: body-size,
    )

    let title-section = section-content({
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

    if full-width-title {
      place(top, scope: "parent", float: true, title-section)
    } else { title-section }

    body
  }

  (
    poster: poster,
    section: section,
    section-content: section-content,
    section-sep: section-sep,
    config: config,
  )
}
