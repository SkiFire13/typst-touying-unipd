#import "@preview/touying:0.5.2"
#import "unipd.typ": *

#show: unipd-theme

#title-slide(
  authors: "Me and myself",
  title: "Some kinda short title",
  subtitle: lorem(12),
  date: "February 2024",
)

== Bar

=== Baz

#slide[
  Altro
]

== Qux

#slide[
  - Foo

  - Bar

  - Baz

    - Cafrax

  - Qux

    - Brux?
]

#new-section-slide("Introduction")

#slide[
  == Static text

  Here's some code:

  ```sh
  #!/bin/bash
  sleep 2
  echo "Hello World"
  exit 0
  ```
]

#slide[
  == Static text

  #lorem(20)

  #uncover("2-")[This appears after one slide]
]

#new-section-slide("Conclusions")

#slide[
  == Qux

  _baz_\
  *Fizz*\
  `Fuzz`
]

#slide[
  #normal-block[Normal block][body]
  #alert-block[Alert block][body]
  #example-block[Example block][
    body

    but a bit longer
  ]
]

#filled-slide[
  Thank you for your attention
]
