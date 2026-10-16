#import "figures.typ": refine-diagram
#import "template.typ": template
#let (poster, section, section-content, section-sep, config) = template(
  columns-gutter-add: -3.55mm,
  list-spacing: 1.0em,
  section-inset: (x: 0.65em, y: 0.65em * 1.12),
  section-sep-size: 1em,
  title-size: 52pt,
  page-margin: 25.5mm,
)
#import "@preview/cades:0.3.1": qr-code

#show: poster.with(
  title: [Interactive typing toolkit:\ the types you want],
  authors: (
    (name: "Oliver Tušla", email: "tuslaoli@fit.cvut.cz"),
    (name: "Mickaël Laurent", email: "mickael.laurent@matfyz.cuni.cz"),
    (name: "Pierre Donat-Bouillud", email: "pierre.donat.bouillud@fit.cvut.cz"),
  ),
)

#section-sep()

#section[The type you get vs. the type you want][
  - JavaScript's `||` is *not boolean*: `0 || "x"` is `"x"`, and `{} || 1` is `{}`.
  - Spelled out, it is *exactly* this function @polymorphic-inference:

  #align(center, ```js
  function logical_or(x, y) {
    if (x) { return x; } else { return y; }
  }
  ```)

  - *Naive type* $(mono("bool"), mono("bool")) -> mono("bool")$ -- too crude, rejects the uses above.
  - *Inferred type*, with no annotations, accounts for all of them:

  #align(center)[
    $forall alpha, beta. space
    ((alpha and mono("truthy"), mono("any")) -> alpha and mono("truthy"))
    space and space
    ((mono("falsy"), beta) -> beta)$
  ]

  - Sound, fully precise, compositional -- and *harder to read*.
  - *We present a VS Code extension for manipulating set-theoretic types* that lets you *interactively reshape an inferred type* and discover its possible shapes.
]

#section-sep()

#section[Set-theoretic types][
  - Built on the MLsem typing library @type-inference: a type *is the set of values* it accepts.
  - The *interpretation* $bracket.l.stroked t bracket.r.stroked$ of a type $t$ is the set of values it denotes; each connective is the matching set operation:

  #v(1em)
  #align(center)[
    $bracket.l.stroked mono(42) bracket.r.stroked = {mono(42)} quad quad
    bracket.l.stroked mono("int") bracket.r.stroked = {dots, 0, 1, dots} \
    bracket.l.stroked t_1 and t_2 bracket.r.stroked = bracket.l.stroked t_1 bracket.r.stroked inter bracket.l.stroked t_2 bracket.r.stroked quad quad
    bracket.l.stroked t_1 or t_2 bracket.r.stroked = bracket.l.stroked t_1 bracket.r.stroked union bracket.l.stroked t_2 bracket.r.stroked$
  ]

  - *Subtyping is then set inclusion*: $s <: t$ exactly when $bracket.l.stroked s bracket.r.stroked subset.eq bracket.l.stroked t bracket.r.stroked$.
  - The full *algebra of sets* -- union, intersection, negation -- over singleton types like $mono("true")$ or $mono(42)$, a top type $mono("any")$, a bottom type $mono("empty")$:
  #{
    let s = h(1.35em)
    align(center)[
      $mono("true") or mono("false") = mono("bool") #s
      mono("int") and mono("string") = mono("empty") #s
      not mono("true") = mono("any") without mono("true")$
    ]
  }
  - Functions are *arrows* $t -> s$; an *intersection of arrows* is *overloading (ad hoc polymorphism)*,
    - $(mono("int") -> mono("int")) and (mono("bool") -> mono("bool"))$ honours both contracts at once,
    - and is strictly more precise than $mono("int")mid(|)mono("bool") -> mono("int")mid(|)mono("bool")$.
  - Type variables $alpha$ give *genericity (parametric polymorphism)*.
  - Subtyping is decided *semantically*, not syntactically -- so inference gets remarkably precise, hence verbose.
]

#section-sep()

#section[Future direction - moving to R][
  - More operations to come:
    - *domain decomposition*, *branch specialization*.
  - Target: *the R language* -- overloaded functions plus pervasive dynamicity make sensible types hard to infer automatically; the toolkit eases the simplicity/expressivity trade-off.
  - Open directions:
    - LLM assisted trade-off search via the toolkit with success criteria.
    - Language-specific features like builtin dispatch mechanisms.
    - Apply the same system to modules and objects.
]

#colbreak()

#section-sep()

#section[Refining a signature, interactively][
  - Inference is *precise but verbose*
    - rarely the type you would write by hand.
  - We demonstrate this with MLsem: it infers an intersection of *two overloads*, then two operations reshape it:

  #align(center, ```ml
  (* vals are inferred overloads *)
  val logical_or : 'a & truthy -> 'b -> 'a & truthy
  val logical_or : 'c & falsy -> 'd -> 'd
  (* let is a definition from the user *)
  let logical_or x y = if x is truthy then x else y
  ```)

  - *Instantiate* -- pin a type variable to a concrete type, per overload.
  - *Merge* -- collapse selected overloads into one arrow, unioning their (co)domains: $(t_1 -> s_1) and (t_2 -> s_2) quad |-> quad (t_1 or t_2) -> (s_1 or s_2)$.

  #figure(
    text(size: 26pt, refine-diagram),
    caption: [Diagram of instantiate and merge operations.],
  )

  - *You* choose where on the precision/readability scale to stop:

  #align(center, ```ml
  val logical_or : bool -> bool -> bool
  val logical_or : truthy -> any -> truthy
  let logical_or x y = if x is truthy then x else y
  ```)

  #v(0.25em)
]

#section-sep()

#section-content[
  #figure(
    image("assets/toolkit.png", width: 100%),
    caption: [The merge and instantiate panels, driven from our LSP server.],
  )
  #v(0.33em)
]

/*
  The `clearance` here is required to convince the layout
  engine to put the section on the same page.
  An alternative is to put this entire `place`
  somewhere in the second column, but not last.
*/
#place(bottom, clearance: -8em, scope: "parent", float: true)[
  #let h = 4em
  #section-content[
    #grid(
      align: center + horizon,
      column-gutter: 1em,
      columns: 4,
      [
        #image("assets/Logo EN colour.svg", height: h)
        // #set align(left)
        This work is supported by the Czech Ministry of Education, Youth and Sports under program ERC-CZ, grant agreement LL2325,
        as well as by the Czech Science Foundation\ Grant No. 23-07580X.
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
      [
        Try for yourself!
        #let repo = "https://github.com/asmarcz/MLsem-vscode"
        #link(repo, {
          let outset = 0.65em
          block(above: outset, below: outset * 0.8, qr-code(repo))
          raw("asmarcz/MLsem-vscode")
        })
      ],
      box(align(top + left, bibliography("works.bib", title: none, style: "assets/acm-sig-proceedings.csl"))),
    )
  ]
]
