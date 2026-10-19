#import "template.typ": *
#import "figures.typ": *

#let section-inset = 0.5em
#let section-border = 3pt
#let margin = 25.5mm
#set page(
  margin: margin, // default 10 cm for A0
  paper: "a0",
  fill: luma(95%)
)

// #rect(width: 100%, height: 100%, fill: red)
#set raw(syntaxes: "assets/bclang.sublime-syntax")

// #set strong(delta: 100)

// #show heading: set text(font: "New Computer Modern")
// #set text(
//   font: "New Computer Modern Sans",
//   size: 32pt,
// )
// #show heading: set text(font: "Libertinus Serif")
// #set text(
//   font: "Inter",
//   size: 32pt,
// )
#show heading: set text(font: "IBM Plex Serif")
#set text(
  font: "IBM Plex Sans",
  size: 32pt,
)
// #{
//   set align(center)
//   heading()[
//     #set text(size: 72pt, weight: "medium")
//     Typestate-oriented Programming with\ Ad-hoc Polymorphism on the Typestate
//   ]
//   set text(size: 48pt)
//   // linebreak()
//   v(0.5em)
//   [
//     Oliver Tušla
//   ]
// }

#set par(justify: true)
#show: columns.with(
  gutter: margin - 2 * section-inset - 2 * section-border - 3.55mm,
)

#let section-content(body) = {
  block(
    fill: white,
    stroke: luma(10%) + section-border,
    inset: section-inset,
  )[
    #set par(spacing: 1.05em)
    #body
  ]
}

#let section(title, body) = {
  set par(spacing: 0pt)
  // set block(fill: luma(95%))
  // set block(fill: white)
  block(
    fill: white,
    stroke: (rest: luma(10%) + section-border, bottom: none),
    inset: section-inset,
    heading(level: 2, title)
  )
  section-content(body)
}

// #{
//   set align(center)
//   heading()[
//     #set text(size: 52pt, weight: "medium")
//     Typestate-oriented Programming with\ Ad-hoc Polymorphism on the Typestate
//   ]
//   set text(size: 48pt)
//   // linebreak()
//   v(0.5em)
//   [
//     Oliver Tušla
//   ]
// }

#section-content({
  box(width: 100%,
    {
      set align(center)
      heading()[
        #set text(size: 52pt, weight: "medium")
        Typestate-oriented Programming with\ Ad-hoc Polymorphism on the Typestate
      ]
      set text(size: 48pt)
      // linebreak()
      v(0.5em)
      [
        Oliver Tušla
      ]
    }
  )
})


#let section-sep() = v(1.1em)

#section([Introduction])[
  We present a design of a typestate-oriented programming language.
  
  Class instances describe their state using `clause` declarations, each intended to capture a single property of the class domain. At any point in the program, each clause in scope has a valuation: `Holds`, `Not`, or `Unknown`. For a clause `Full`, we represent its current valuation using the boxes #clause(holds-color, [Full]), #clause(not-color, [Full]), and #clause(unknown-color, [Full]) respectively. Traditional typestate approaches enumerate all possible combinations of properties, resulting in $2^n$ or $3^n$ number of states - an explosion in the number of declarations. *Our approach alleviates this problem by allowing users to reason about properties individually.*
  
  Methods manipulate clause valuations. Declarations include a `makes` list specifying postconditions that must hold after method execution. Method is a set of implementations that differ only in their `takes` lists, specifying their preconditions. Methods are ad-hoc polymorphic on the state of their receiver and the states of their parameters. *This aids code organization, encapsulation, observability and performance.* We use a box like #impl([`#0`]) to disambiguate a method's first implementation. A method may freely alter the valuation of clauses in its own class. However, to affect the state of an instance of another class, it must do so by calling that class’s methods.
]

#section-sep()

#section([Example of a Strict Domain Definition])[
  #jar-domain

  The `Jar` class models a strict domain, e.g., only a non-empty jar may be dumped, only a non-full jar may be filled, etc.
]

#section-sep()

#section([Clause valuation rules - (pre/post)conditions])[
  #let manual = 0.334em

  #v(manual)

  #align(center,
    clause-valuation-diag
  )
  
  Method implementation bodies must adhere to the clause valuation rules depicted in the diagram. Checked blocks may also refine clause valuations, using the same rules. The loop refines a jar instance. The `takes` list acts as a loop invariant, enforced at every `continue`, while the `makes` list acts as a postcondition, checked at every `break`. In the left-hand example, the `add_max()` call does not type check, and we exclude it from further discussion.
  
  #jar-loop

  #v(manual)
]

#section([Ad-hoc Polymorphism on State])[
  #screen-example
  // #v(-0.5em)
  After the screen dimensions are externally modified, all clause valuations are invalidated. We restore these properties using `decide`, which introduces two scopes, each with a distinct valuation of a clause. Subsequently, the restored valuations are leveraged by the type checker to select an appropriate implementation of the `cut_max_square()` method.
]

#section-sep()

#section([Trust and Forget statements])[
  #bank-account
  // #v(-0.5em)
  Clause valuations are not invalidated when modifying instance variables within the same class. To help implementors avoid unintentionally violating domain invariants, the `forget` and `trust` statements can be used, similarly to `defer` statements in other languages, as shown in the `pay()` method. Likewise, if a clause valuation introduced by a nested call conflicts with the method's declared signature, the implementor must explicitly assert that the correct property has been reestablished, as shown in `gov_distrainor()`.
]


// #lorem(1000)