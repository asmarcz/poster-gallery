#import "figures.typ":
#import "template.typ": template
#let start-stop-color = rgb("#d1e0fa")
#let (poster, section, section-auto, section-auto-end, section-content, section-sep, title-block, config) = template(
  authors-size: 28pt * 0.9,
  body-size: 28pt,
  corner-radius: 0.4em,
  page-fill: gradient.linear(
    start-stop-color,
    rgb("#dfe5ef"),
    start-stop-color,
    angle: 135deg,
  ),
  section-sep-size: 1.00em,
)
#import "@preview/cades:0.3.1": qr-code

#let title = [Characterizing Type Feedback\ in Just-in-Time Compilation]
#let authors = (
  (name: "Sebastián Krynski", email: "skrynski@gmail.com"),
  (name: "Filip Říha", email: "rihafili@fit.cvut.cz"),
  (name: "Filip Křikava", email: "filip.krikava@fit.cvut.cz"),
  (name: "Jan Vitek", email: "vitekj@icloud.com"),
  (name: "Oliver Tušla", email: "tuslaoli@fit.cvut.cz"),
)

#show: poster.with(title: title, authors: authors)
#show divider: _ => {
  let s = 1.8em
  set block(above: s, below: s)
  line(length: 100%, stroke: config.section-border + black)
}

#let fig(path, ..params) = image("../paper/figures/" + path, ..params)

// A figure with caption, sized to the column.
#let cfig(path, caption, width: 100%) = block(width: 100%, breakable: false, {
  set align(center)
  fig(path, width: width)
  v(0.3em)
  set text(size: 0.78em)
  set par(justify: false)
  emph(caption)
})

// A compact number callout.
#let stat(number, label) = block(
  fill: luma(95%),
  inset: 0.5em,
  radius: 4pt,
  width: 100%,
)[
  #set align(horizon)
  #grid(
    columns: (auto, 1fr),
    column-gutter: 0.6em,
    align: (center + horizon, left + horizon),
    text(size: 1.7em, weight: "bold", context {
      let m = measure(number)
      number
      let upto = text(size: 0.3em, weight: "medium")[up to]
      let m2 = measure(upto)
      place(dx: m.width / 2 - m2.width / 2, dy: -100%, upto)
    }),
    text(size: 0.85em)[#label],
  )
]

// ---- QR / call-to-action block (from the prepared scaffold) ----
#let poster-qr-code(href, head, foot, qr-width: auto) = align(center, {
  head
  link(href, {
    block(above: 0.55em, below: 0.4em, qr-code(href, width: qr-width))
    text(size: 0.8em, foot)
  })
})

#let figure-width = 100%
#let jan-fig-width = 93.1%

#let sounds-interesting = context {
  section-content(
    // [Sounds interesting?],
    {
      let qr-width = 7em
      let talk = poster-qr-code(
        "https://2026.ecoop.org/details/ecoop-2026-technical-papers/21/Characterizing-Type-Feedback-in-Just-in-Time-Compilation",
        [Attend the talk!],
        [Thursday at 14:22],
        qr-width: qr-width,
      )
      let paper = poster-qr-code(
        "https://drops.dagstuhl.de/entities/document/10.4230/LIPIcs.ECOOP.2026.16",
        [Read the paper!],
        raw("10.4230/LIPIcs.ECOOP.2026.16"),
        qr-width: qr-width,
      )
      let w = calc.max(measure(talk).width, measure(paper).width)
      align(center, grid(
        align: center,
        columns: (w, w),
        column-gutter: 1em,
        talk, paper,
      ))
    },
  )
}

#let problem-section = section([The Problem], [
  - JIT compilers speed up dynamic languages by *recording runtime observations*, then
    *specializing* the compiled code to them.
  - Recording *slows the interpreter* --- and the cost is often *wasted*:
    - many functions never get hot enough to compile,
    - execution falls back to the interpreter after a *deoptimization*,
    - short-running scripts never amortize it.
  // #set block(above: config.list-spacing)
  + *How* does the compiler actually *use* recorded feedback --- and how much is left unused?
  + Can we *record less* without hurting *peak performance*?

  === Our approach
  + Instrument *Ř*, a JIT compiler for *R*
    --- laziness and reflection make recording especially aggressive.
  + *Snapshot and classify every slot* during compilation.
  + Do this on a corpus of *14 benchmarks*, *3 Kaggle notebooks*,\ and the *Recommenderlab* library -- thousands of slots.
])

#let type-feedback-section = section([Type Feedback 101], [
  - Three kinds recorded: *types*, *call targets*, *branch decisions* --- we study
    *types*.
  - A type descriptor is a nominal type plus suffixes: (`$`) = *scalar* (length-1
    vector),\ (`-`) = *no attributes*, (`+`) = *attributes but not an object*, bare =
    *maybe an object*.
  - These form a *lattice*. Each instruction that may be speculated has a *slot* recording the
    type it observes; a function's slots make up its *feedback vector*. Repeated
    observations on a slot *merge* ($union.sq$) and lose precision (*pollution*).

  #align(center, fig("observed-values.pdf", width: 84.6%))

  The compiler reasons with *three* types per instruction:
  - *Inferred* ($"IT"$) --- known statically by dataflow analysis,
  - *Observed* ($"OT"$) --- recorded into the slot at runtime,
  - *Expected* ($"ET"$) $"IT" inter.sq "OT"$ --- what it actually speculates on.
  Speculation pays off *only* when $"ET"$ is *more precise than* $"IT"$.
])

#let compiler-use-section = section([What the Compiler Actually Uses], [

  We snapshot every feedback slot during compilation and classify each as:
  - *Used* --- speculated on (exact match, or narrowed / widened).
  - *Unused but present* --- survived, but the type was *stable* (inferred already
    matches observed) or speculation was *blocked*.
  - *Unused and missing* --- *eliminated* during optimization.
  #v(0.5em)

  #fig("feedback-slot-taxonomy.pdf", width: figure-width)

  #v(0.5em)
  #grid(
    columns: (1fr, 1fr),
    column-gutter: 0.6em,
    stat([59%], [of non-empty feedback slots are *never used* by the compiler]),
    stat([1.6#sym.times], [interpreter recording overhead (mean 1.2#sym.times)]),
  )
  #v(0.5em)

  This waste is mostly explained. Of these unused slots:
  - *≈43%* are *dead code* -- eliminated before they could be used;
  - most of the rest are *type-stable* -- the inferred type already matches the
    observed one, so speculation cannot help.
  #v(0.5em)

  #cfig(
    "graphs/used.pdf",
    width: figure-width,
    [Ratio of *used* slots out of non-empty slots, per program -- only about a
      quarter are ever used.],
  )
])

#let bounding-gain-section = section([How Much Could We Save?], [
  Oracle configurations are upper bounds
  on what selective recording could achieve:
  - *Baseline* --- record *every* slot (what Ř does today).
  - *Conservative set*
    - keep every slot the compiler *uses at any point* during
      compilation.
    - the interpreter *speeds up* -- there is less to record,
    - *peak performance stays at baseline* -- the same slots were used for optimization.
  - *Optimistic set*
    - keep only slots whose speculation *survives into the final
      optimized code*.
    - the interpreter speeds up *even more*,
    - *peak performance
      drops* on some compute-heavy programs
      \ #sym.arrow some slots that were used for intermediate optimizations were removed.

  #cfig(
    "janspeedup.pdf",
    width: jan-fig-width,
    [Interpretation speedup (top) and peak performance (bottom), normalized to the
      all-slots baseline.],
  )
])

#let footer = {
  let h = 2.75em
  section-content[
    #grid(
      align: center + horizon,
      column-gutter: 1em,
      columns: 4,
      [
        #set align(left)
        === Takeaway
        - JIT compilers record *far more feedback than they use*.
        - *Dead-code* and *type-stable* slots are wasteful.
        - Recording *far less is possible\ without sacrificing optimization quality*.
          \ #box[#sym.arrow.r] Future work: *predictive, selective recording*.
      ],
      context {
        let qr-width = 7em
        let talk = poster-qr-code(
          "https://2026.ecoop.org/details/ecoop-2026-technical-papers/21/Characterizing-Type-Feedback-in-Just-in-Time-Compilation",
          [Attend the talk!],
          [Thursday at 14:22],
          qr-width: qr-width,
        )
        let paper = poster-qr-code(
          "https://drops.dagstuhl.de/entities/document/10.4230/LIPIcs.ECOOP.2026.16",
          [Read the paper!],
          raw("10.4230/LIPIcs.ECOOP.2026.16"),
          qr-width: qr-width,
        )
        let w = calc.max(measure(talk).width, measure(paper).width)
        align(center, grid(
          align: center,
          columns: (w, w),
          column-gutter: 1em,
          talk, paper,
        ))
      },
      [
        #image("assets/Logo EN colour.svg", height: h)
        // #set align(left)
        This work is supported by the Czech Ministry of Education, Youth and Sports under program ERC-CZ, grant agreement LL2325,
        as well as by the Czech Science Foundation Grant No. 23-07580X.
      ],
      {
        set par(spacing: 0.5em)
        block({
          set align(left)
          image("assets/logo-fit-en-pantone.pdf", height: h)
          move(
            dx: .075em,
            image("assets/PR-56-version1-uk_uzitna_eng_barevna_fullhd.png", height: h),
          )
        })
        grid(
          columns: 2,
          image("assets/prl-final-2.png", height: h),
          {
            set align(bottom)
            image("assets/d3s-logo.svg.png", height: h * 0.9)
          },
        )
      },
    )
  ]
}

#let top-cols = columns(2, gutter: 1em, {
  title-block(title, authors)
  section-sep()

  v(.021em)
  problem-section

  colbreak()
  type-feedback-section
})

#let middle-cols = columns(
  2,
  gutter: 1em,
  {
    compiler-use-section
    colbreak()
    bounding-gain-section
  },
)

#v(1fr)
#top-cols
#divider()
#middle-cols
#divider()
#footer
#v(1fr)
