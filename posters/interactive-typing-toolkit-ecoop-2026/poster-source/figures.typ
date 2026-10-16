#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

#let refine-diagram = {
  let decl-col = luma(94%)
  let keep-col = blue
  let merge-col = orange
  let d-tag(t) = raw(t)
  let d-title(t, body) = align(left)[
    #text(0.85em, fill: luma(20%), style: "italic", weight: "medium")[#t] \ #body
  ]

  diagram(
    edge-stroke: 1.6pt,
    mark-scale: 120%,
    node-corner-radius: 4pt,
    node-inset: 10pt,
    node-outset: 4pt,
    node-stroke: 1.25pt,

    let inferred-coords = (1, 0),
    let keep-coords = (0.1, 1),
    let merge-l-coords = (1, 1),
    let merge-r-coords = (1.8, 1),
    let merge-coords = (1, 2),
    let melded-coords = (1, 3),
    let copy-coords = (0.3, 2),

    node(
      inferred-coords,
      d-title("inferred", raw("'a & truthy -> 'b -> 'a & truthy\n'c & falsy  -> 'd -> 'd")),
      fill: decl-col,
    ),

    edge(inferred-coords, keep-coords, "-|>", d-tag("'a, 'b := any"), label-pos: 0.6, label-side: right),
    edge(inferred-coords, merge-l-coords, "-|>", d-tag("'a, 'b := bool"), label-pos: 0.6, label-side: right),
    edge(inferred-coords, merge-r-coords, "-|>", d-tag("'c, 'd := bool"), label-pos: 0.6, label-side: left),

    node(keep-coords, raw("truthy -> any -> truthy"), stroke: keep-col + 1pt, fill: keep-col.lighten(92%)),
    node(
      merge-l-coords,
      align(left, raw("true  -> bool -> true")),
      stroke: merge-col + 1pt,
      fill: merge-col.lighten(90%),
    ),
    node(
      merge-r-coords,
      align(left, raw("false -> bool -> bool")),
      stroke: merge-col + 1pt,
      fill: merge-col.lighten(90%),
    ),

    edge(merge-l-coords, merge-coords, "-|>"),
    edge(merge-r-coords, merge-coords, "-|>"),
    node(
      merge-coords,
      align(center)[merge \ #text(0.8em)[union domains]],
      fill: merge-col.lighten(75%),
      stroke: merge-col + 1pt,
      shape: fletcher.shapes.pill,
      inset: 0.65em,
    ),

    edge(keep-coords, melded-coords, "-|>", label-pos: 0.3, bend: -22deg),
    edge(merge-coords, melded-coords, "-|>"),
    node(melded-coords, d-title("melded", raw("bool   -> bool -> bool\ntruthy -> any  -> truthy")), fill: decl-col),
    node(
      copy-coords,
      align(center)[copy],
      fill: keep-col.lighten(92%),
      stroke: keep-col + 1pt,
      shape: fletcher.shapes.pill,
      inset: 0.65em,
    ),
  )
}
