#let _code-common(
  caption,
  label,
  content,
  annotations: (),
  display-lang: true,
  inset: (right: 0.15em),
  lang-outset: (x: 0em, y: 0em),
  line-numbers: true,
  placement: none,
  ..pass
) = {
  // import "@preview/codly:1.3.0": *
  import "codly/codly.typ": *
  import "@preview/codly-languages:0.1.1": *
  show: codly-init.with()
  codly(
    annotations: annotations,
    annotation-format: none,
    display-icon: display-lang,
    display-name: display-lang,
    number-align: right + horizon,
    inset: inset,
    lang-outset: lang-outset,
    languages: codly-languages,
    zebra-fill: none,
  )
  
  [
      #local(
        ..pass,
        content
      )
  ]
}

#let code1(
  caption,
  label,
  code,
  ..common,
) = {
  _code-common(
    caption,
    label,
    ..common,
    code,
  )
}

#let code2(
  caption,
  label,
  code-lhs,
  code-rhs,
  columns: (auto, auto),
  lhs: (),
  rhs: (),
  ..common,
) = {
  // import "@preview/codly:1.3.0": *
  import "codly/codly.typ": *
  _code-common(
    caption,
    label,
    ..common,
    {
      grid(
        columns: columns,
        {
          local(
            ..lhs,
            code-lhs
          )
        },
        {
          local(
            ..rhs,
            code-rhs
          )
        },
      )
    }
  )
}

#let language-name = "BcLang"
#let err-color = red.lighten(60%)
#let ok-color = green.lighten(60%)
#let holds-color = green.lighten(40%)
#let not-color = red.lighten(40%)
#let unknown-color = yellow.lighten(18%)

#let impl(name) = {
  // font: https://github.com/typst/typst/pull/6000
  // set text(font: "DejaVu Sans Mono")
  box(
    baseline: 25%,
    inset: 0.3em,
    fill: blue.lighten(80%),
    radius: 0.32em, // consistent with codly
    text(size: 0.88em, name)
  )
  h(0.25em)
}
#let clause(state, name) = {
  box(
    baseline: 25%,
    // inset: 0.34em,
    inset: 0.3em,
    fill: state,
    radius: 0.32em, // consistent with codly
    text(size: 0.88em, name)
    // name
  )
}
#let clauses(..pairs) = {
  // set text(size: 0.885em)
  for (state, name) in pairs.pos() {
    clause(state, name)
    h(0.25em)
  }
}