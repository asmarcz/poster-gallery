#import "template.typ": *
#import "@preview/fletcher:0.5.7" as fletcher: diagram, node, edge

#let jar-domain = code1(
  [Jar class definition],
  <jar-definition>,
  ```bc
  class Jar {
    clause Empty; clause Full; var coins: i64

    static method new() -> Jar makes Empty, not Full {{
      return Jar { coins: 0 }
    }}

    method dump_all() makes Empty, not Full {
      takes not Empty { coins = 0 } }

    // returns (the number of) coins that were dumped
    method dump(n: i64) -> i64 makes any Empty, any Full {
      takes not Empty, not n.Negative {
        let old: i64 = coins
        if coins - n < 0 { coins = 0 }
        else { coins = coins - n }
        return old - coins
      }}

    method fill() makes not Empty, Full {
      takes not Full { coins = MAX } }

    method add_max() makes not Empty, Full {
      takes Empty { coins = MAX } }
  }
  ```,
  display-lang: false,
  inset: (y: 0.1em),
  // placement: auto,
)

// ```

//     // returns (the number of) coins that did not fit
//     method add_positive(n: i64) -> i64 makes not Empty, any Full {
//       takes not Full, n.Positive {
//         let old: i64 = coins
//         if coins + n > MAX { coins = MAX }
//         else { coins = coins + n }
//         return old + n - coins
//       }}

//     method check_empty() -> State {{
//       if coins == 0 { return State::Holds }
//       else { return State::Not } }}

//     method check_full() -> State {{
//       if coins == MAX { return State::Holds }
//       else { return State::Not } }}
// ```



#let jar-loop = {
  let highlight-inset = (left: 0.1em, y: 0.29em)
  code2(
    [Loop with a checked block],
    <loop-simple>,
    ```bc
    class Temp { method temp() {{
    let j: Jar = Jar::new()
    loop takes not j.Full  
         makes not j.Empty,any j.Full{
      ❌ j.add_max()       
      j.fill()             
      if rand_bool() {
        break              
      }
      j.dump_all()         
    }                      
    j.dump_all()           
    } }}
    ```,
    // class Temp { method temp() {{
    // let j: Jar = Jar::new()
    // loop takes not j.Full  
    //      makes not j.Empty {
    //   let n: i64 =
    //     rand_i64(1, MAX)   
    //   j.add(n)             
    //   j.dump(n)            
    // }
    // } }}
    ```bc
    class Temp { method temp() {{
    let j: Jar = Jar::new()
    loop takes not j.Full  
         makes not j.Empty {
      let n: i64 =         
        rand_i64(1, MAX)   
      j.add_positive(n)    
      j.dump(n)            
      ❌ continue          
    }                      
    j.dump_all()           
    } }}
    ```,
    display-lang: false,
    // inset: (x: 0.15em),
    inset: (x: 0.15em, y: 0.1em),
    lhs: (
      number-format: none,
      // inset: (x: 0.15em, y: 0.22em),
      offset: -1,
      range: (2, 12),
      highlight-inset: highlight-inset,
      highlights: (
        (line: 1, fill: rgb(0, 0, 0, 0), tag: clauses((holds-color, [Empty]), (not-color, [Full]))),
        (line: 2, fill: rgb(0, 0, 0, 0), tag: clauses((unknown-color, [Empty]), (not-color, [Full]))),
  
        (line: 4, start: 3, end: 17, fill: red),
        (line: 4, start: 3, fill: rgb(0, 0, 0, 0), tag: clauses((unknown-color, [Empty]), (not-color, [Full]))),
        
        (line: 5, fill: rgb(0, 0, 0, 0), tag: clauses((not-color, [Empty]), (holds-color, [Full]))),
        (line: 7, fill: rgb(0, 0, 0, 0), tag: clauses((not-color, [Empty]), (holds-color, [Full]))),
  
        
        (line: 9, fill: rgb(0, 0, 0, 0), tag: clauses((holds-color, [Empty]), (not-color, [Full]))),
        (line: 10, fill: rgb(0, 0, 0, 0), tag: clauses((not-color, [Empty]), (unknown-color, [Full]))),
  
        (line: 11, fill: rgb(0, 0, 0, 0), tag: clauses((holds-color, [Empty]), (not-color, [Full]))),
      ),
    ),
    rhs: (
      number-format: none,
      // inset: (x: 0.15em, y: 0.23em),
      offset: -1,
      range: (2, 11),
      annotation-format: none,
      annotations: (
        (start: 4, end: 6, content: box(height: 2.66em, sym.space.nobreak)), // TODO this is desperate
      ),
      highlight-inset: highlight-inset,
      highlights: (
        (line: 1, fill: rgb(0, 0, 0, 0), tag: clauses((holds-color, [Empty]), (not-color, [Full]))),
        (line: 2, fill: rgb(0, 0, 0, 0), tag: clauses((unknown-color, [Empty]), (not-color, [Full]))),

        (line: 4, fill: rgb(0, 0, 0, 0), tag: clauses((not-color, [Negative]))),
        (line: 5, fill: rgb(0, 0, 0, 0), tag: clauses((holds-color, [Positive]))),

        (line: 6, fill: rgb(0, 0, 0, 0), tag: clauses((not-color, [Empty]), (unknown-color, [Full]))),
        (line: 7, fill: rgb(0, 0, 0, 0), tag: clauses((unknown-color, [Empty]), (unknown-color, [Full]))),

        (line: 8, start: 3, end: 14, fill: red),
        (line: 8, start: 3, fill: rgb(0, 0, 0, 0), tag: clauses((unknown-color, [Empty]), (unknown-color, [Full]))),

        (line: 9, fill: rgb(0, 0, 0, 0), tag: clauses((not-color, [Empty]), (not-color, [Full]))),

        (line: 10, fill: rgb(0, 0, 0, 0), tag: clauses((holds-color, [Empty]), (not-color, [Full]))),

        
        // (line: 2, fill: rgb(0, 0, 0, 0), tag: clauses((unknown-color, [Empty]), (not-color, [Full]))),
        // (line: 1, fill: rgb(0, 0, 0, 0), tag: clauses((holds-color, [Empty]), (not-color, [Full]))),

        // (line: 5, fill: rgb(0, 0, 0, 0), tag: clauses((holds-color, [Positive]))),

        // (line: 6, fill: rgb(0, 0, 0, 0), tag: clauses((not-color, [Empty]), (unknown-color, [Full]))),
        // (line: 7, fill: rgb(0, 0, 0, 0), tag: clauses((unknown-color, [Empty]), (not-color, [Full]))),
      ),
    ),
    // placement: auto,
  )
}


#let screen-example = code2(
  [Screen example domain],
  <screen-example>,
  ```bc
  class Screen {
    clause Square; clause Wide
    pub var height: i64; pub var width: i64
    
    static method new_wide() -> Screen makes not Square, Wide
      {{ return Screen { height: 1080, width: 1920 } }}

    method cut_max_square() makes Square, not Wide {
      {
        if height < width { width = height }
        else { height = width }
      }
      takes Square {}
      takes Wide { width = height }
    }

    method render_into_square() { takes Square { .. } }

    method check_square() -> State {{
      if height == width { return State::Holds }
      else { return State::Not }
    }}

    method check_wide() -> State {{
      if height < width { return State::Holds }
      else { return State::Not }
    }}
  }
  ```,
  ```bc
  class Temp {method temp() {{
  var screen: Screen = Screen::new_wide()              
  if rand_bool() { screen.height = screen.width }      
  else { screen.width = screen.width * 2 }             
  decide screen Wide {                                 
    screen.cut_max_square()                        
  } else {                                             
    decide screen Square {                             
      println("Suspicious, better safe than sorry!")
      screen.cut_max_square()                      
    } else {                                           
      screen.cut_max_square()                      
    }                                                  
  }                                                    
  screen.render_into_square()                          
  } }}
  ```,
  columns: (auto),
  display-lang: false,
  // placement: auto,
  inset: (x: 0.2em, y: 0.1em),
  lhs: (
    highlight-inset: (
      right: 0.25em,
      y: 0em,
    ),
    highlights: (
      (line: 9, fill: rgb(0, 0, 0, 0), tag: impl([\#0])),
      (line: 13, fill: rgb(0, 0, 0, 0), tag: impl([\#1])),
      (line: 14, fill: rgb(0, 0, 0, 0), tag: impl([\#2])),
    ),
  ),
  rhs: (
    offset: -1,
    range: (2, 15),
    highlight-inset: (
      right: 0.25em,
      y: 0.15em
    ),
    highlights: (
      (line: 1, fill: rgb(0, 0, 0, 0), tag: clauses((not-color, [Square]), (holds-color, [Wide]))),
      (line: 2, fill: rgb(0, 0, 0, 0), tag: clauses((unknown-color, [Square]), (unknown-color, [Wide]))),
      (line: 3, fill: rgb(0, 0, 0, 0), tag: clauses((unknown-color, [Square]), (unknown-color, [Wide]))),
      
      (line: 4, fill: rgb(0, 0, 0, 0), tag: clauses((unknown-color, [Square]), (holds-color, [Wide]))),

      (line: 5, end: 25, fill: rgb(0, 0, 0, 0), tag: impl([\#2])),
      (line: 5, fill: rgb(0, 0, 0, 0), tag: clauses((holds-color, [Square]), (not-color, [Wide]))),

      (line: 6, fill: rgb(0, 0, 0, 0), tag: clauses((unknown-color, [Square]), (not-color, [Wide]))),
      
      (line: 7, fill: rgb(0, 0, 0, 0), tag: clauses((holds-color, [Square]), (not-color, [Wide]))),

      (line: 9, end: 27, fill: rgb(0, 0, 0, 0), tag: impl([\#1])),
      (line: 9, fill: rgb(0, 0, 0, 0), tag: clauses((holds-color, [Square]), (not-color, [Wide]))),
      
      (line: 10, fill: rgb(0, 0, 0, 0), tag: clauses((not-color, [Square]), (not-color, [Wide]))),
      
      (line: 11, end: 27, fill: rgb(0, 0, 0, 0), tag: impl([\#0])),
      (line: 11, fill: rgb(0, 0, 0, 0), tag: clauses((holds-color, [Square]), (not-color, [Wide]))),

      (line: 12, fill: rgb(0, 0, 0, 0), tag: clauses((holds-color, [Square]), (not-color, [Wide]))),
      (line: 13, fill: rgb(0, 0, 0, 0), tag: clauses((holds-color, [Square]), (not-color, [Wide]))),

      (line: 14, fill: rgb(0, 0, 0, 0), tag: clauses((holds-color, [Square]), (not-color, [Wide]))),
    ),
  ),
)


#let bank-account = code1(
  [Bank account domain using `trust` and `forget`],
  <bank-account-trust>,
  ```bc
  class BankAccount {
    clause AboveMin
    var balance: i64

    static method new_funded() makes AboveMin {{
      return BankAccount { balance: 100 } }}
    
    method pay(amount: i64) -> bool { takes AboveMin {
      balance = balance - amount                           
      forget AboveMin                                      
      if balance < 100 {
        balance = balance + amount                         
        trust AboveMin                                     
        return false                                       
      } else {
        trust AboveMin                                     
        return true                                        
      }
    }}

    method bankrupt() makes not AboveMin {{ balance = 0 }}

    method gov_distrainor(debt: i64) makes AboveMin {{
      if debt + 100 > balance {                            
        bankrupt()                                         
        balance = 100 // social security                   
        trust AboveMin                                     
      } else { balance = balance - debt }                  
    }}
  }
  ```,
  inset: (x:0.2em, y: 0.1em),
  display-lang: false,
  highlight-inset: 0em,
  highlights: (
    (line: 9, fill: rgb(0, 0, 0, 0), tag: clause(holds-color, [AboveMin])),
    (line: 10, fill: rgb(0, 0, 0, 0), tag: clause(unknown-color, [AboveMin])),
    (line: 12, fill: rgb(0, 0, 0, 0), tag: clause(unknown-color, [AboveMin])),
    (line: 13, fill: rgb(0, 0, 0, 0), tag: clause(holds-color, [AboveMin])),
    (line: 14, fill: rgb(0, 0, 0, 0), tag: clause(holds-color, [AboveMin])),
    (line: 16, fill: rgb(0, 0, 0, 0), tag: clause(holds-color, [AboveMin])),
    (line: 17, fill: rgb(0, 0, 0, 0), tag: clause(holds-color, [AboveMin])),

    (line: 24, fill: rgb(0, 0, 0, 0), tag: clause(unknown-color, [AboveMin])),
    (line: 25, fill: rgb(0, 0, 0, 0), tag: clause(not-color, [AboveMin])),
    (line: 26, fill: rgb(0, 0, 0, 0), tag: clause(not-color, [AboveMin])),
    (line: 27, fill: rgb(0, 0, 0, 0), tag: clause(holds-color, [AboveMin])),
    (line: 28, fill: rgb(0, 0, 0, 0), tag: clause(unknown-color, [AboveMin])),
  ),
)

#let clause-valuation-diag = [
  #diagram(
    // debug: 1,
    node-stroke: 0.5pt,
    node-outset: 2pt,
    spacing: 1.5em,
    {
      // let (A, B, C) = ((0, -2), (1.5, -2), (3, -2)); 
      // let bend = -10deg
      let (A, B, C) = ((0, 0), (1.5, 0), (3, 0)); 
      let bend = 10deg
      node(A, [In `makes`?])
      node((1, -1), [
        Valuation mutable.\
        Must match `makes`.
      ])
      edge(A, "-|>", (1, -1), bend: bend)[Yes]
      edge(A, "-|>", B)[No]
      node(B, [In `takes`?])
      node((3, -1), [
        Valuation mutable.\
        Must match `takes`.
      ])
      node(C, [Valuation immutable.])
      edge(B, "-|>", (3, -1), bend: bend)[Yes]
      edge(B, "-|>", C)[No]
    }
  )
]