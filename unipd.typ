#import "@preview/touying:0.5.2": *

#let _header-logo = (colors, ..args) => {
  let original = read("logo_text.svg")
  let colored = original.replace("#B20E10", colors.neutral-lightest.to-hex())
  image.decode(colored, ..args)
}

#let _footer-wave = (colors, ..args) => {
  let original = read("bg_wave.svg")
  let colored = original.replace("#9b0014", colors.primary.to-hex())
  image.decode(colored, ..args)
}

#let _title-background = (colors, ..args) => {
  let original = read("bg.svg")
  let colored = original.replace("#9b0014", colors.primary.to-hex()).replace("#484f59", colors.secondary.to-hex())
  image.decode(colored, ..args)
}

#let _background-logo = (colors, ..args) => {
  let original = read("logo_text.svg")
  let colored = original.replace("#B20E10", colors.primary.to-hex())
  image.decode(colored, ..args)
}

#let _header(self) = {
  set align(top)
  place(rect(width: 100%, height: 100%, stroke: none, fill: self.colors.primary))
  place(horizon + right, dx: -1.5%, _header-logo(self.colors, height: 90%))
  place(horizon + left, dx: 2.5%, text(size: 46pt, fill: self.colors.neutral-lightest, utils.display-current-heading(level: 2)))
}

#let _footer(self) = {
  place(bottom, _footer-wave(self.colors, width: 100%))
  place(
    bottom + right, dx: -2.5%, dy: -25%,
    text(
      size: 18pt,
      fill: self.colors.primary.lighten(50%),
      context utils.slide-counter.display() + " of " + utils.last-slide-number
    )
  )
}

#let slide(
  title: none,
  config: (:),
  repeat: auto,
  setting: body => body,
  composer: auto,
  ..bodies,
) = touying-slide-wrapper(self => {
  let self = utils.merge-dicts(
    self,
    config-page(
      header: _header,
      footer: _footer,
    ),
  )
  let new-setting = body => {
    show: block.with(width: 100%, inset: (x: 3em), breakable: false)
    set text(fill: self.colors.neutral-darkest)
    show: setting
    v(2.5fr)
    if title != none {
      show: block.with(inset: (x: -1.5em, y: -.5em))
      set text(size: 35pt, weight: "bold", fill: self.colors.primary)
      title
      v(.7em)
    }
    body
    v(2fr)
  }
  touying-slide(self: self, config: config, repeat: repeat, setting: new-setting, composer: composer, ..bodies)
})

#let title-slide(
  extra: none,
  ..args,
) = touying-slide-wrapper(self => {
  let info = self.info + args.named()
  let body = {
    // Background
    place(top, _title-background(self.colors, width: 100.1%))
    place(
      bottom + right, dx: -5%, dy: -5%,
      _background-logo(self.colors, height: 18%)
    )

    // // Normalize data
    if type(info.subtitle) == none {
      info.subtitle = ""
    }
    if type(info.authors) != array {
      info.authors = (info.authors,)
    }
    if type(info.date) == none {
      info.date = ""
    }

    set text(fill: self.colors.neutral-lightest)

    // Title, subtitle, author and date
    v(20%)
    align(
      center,
      box(inset: (x: 2em), text(size: 46pt, info.title))
    )

    align(
      center,
      box(inset: (x: 2em), text(size: 30pt, info.subtitle))
    )
    v(5%)
    // TODO: Max 2 columns, last in a single column
    block(width: 100%, inset: (x: 2em), grid(
      rows: (auto,),
      columns: (1fr,) * info.authors.len(),
      column-gutter: 2em,
      ..info.authors.map(author => align(center, text(size: 24pt, author)))
    ))
    place(bottom, dx: 7.5%, dy: -30%, text(size: 24pt, info.date))
  }
  self = utils.merge-dicts(
    self,
    config-common(freeze-slide-counter: true),
    config-page(fill: self.colors.neutral-lightest, margin: 0em),
  )
  touying-slide(self: self, body)
})

#let filled-slide(
  config: (:),
  repeat: auto,
  setting: body => body,
  composer: auto,
  ..bodies,
) = touying-slide-wrapper(self => {
  let self = utils.merge-dicts(self, config-page(margin: 0em))
  let new-setting = body => {
    set text(size: 44pt, fill: self.colors.neutral-lightest)
    show: box.with(width: 100%, height: 100%, fill: self.colors.primary)
    show: align.with(center + horizon)
    show: setting
    body
  }
  touying-slide(self: self, config: config, repeat: repeat, setting: new-setting, composer: composer, ..bodies)
})

#let new-section(title) = heading(level: 2, depth: 2, title)

#let new-section-slide(
  config: (:),
  repeat: auto,
  setting: body => body,
  composer: auto,
  title,
) = new-section(title) + touying-slide-wrapper(self => {
  let self = utils.merge-dicts(
    self,
    config-page(
      header: _header,
      footer: _footer,
    ),
  )
  let new-setting = body => {
    show: align.with(center + horizon)
    set text(size: 34pt, fill: self.colors.primary, weight: "bold")
    show: setting
    body
  }
  touying-slide(self: self, config: config, repeat: repeat, setting: new-setting, composer: composer, utils.display-current-heading(level: 2))
})

#let unipd-theme(
  ..args,
  body,
) = {
  show: touying-slides.with(
    config-page(
      paper: "presentation-4-3",
      header-ascent: 0em,
      footer-descent: 0em,
      margin: (x: 0em, top: 12%, bottom: 12%),
    ),
    config-common(
      slide-fn: slide,
      // new-section-slide-fn: new-section-slide,
    ),
    config-methods(
      init: (self: none, body) => {
        set text(font: "New Computer Modern Sans", size: 24pt, fill: self.colors.neutral-darkest)
        show heading.where(level: 2): set text(fill: self.colors.primary)
        show heading.where(level: 2): it => it + v(1em)
        set list(indent: 1em, marker: text("•", fill: self.colors.primary.darken(20%)))
        // show strong: self.methods.alert.with(self: self)

        body
      },
      cover: (self: none, body) => {
        set text(fill: (self.colors.cover)(self))
        body
      },
      // alert: utils.alert-with-primary-color,
    ),
    config-colors(
      primary: rgb(155, 0, 20),
      secondary: rgb(72, 79, 89),
      tertiary: rgb(0, 128, 0),
      neutral-lightest: rgb("#ffffff"),
      neutral-darkest: rgb("#000000"),
      cover: self => self.colors.neutral-dark.lighten(80%)
    ),
    ..args
  )

  body
}

#let (alert-block, normal-block, example-block) = {
  let make_block_fn(mk-header-color) = (title, body) => touying-fn-wrapper((self: none) => {
    show: it => align(center, it)
    show: it => box(width: 85%, it)
    let slot = box.with(width: 100%, outset: 0em, stroke: self.colors.neutral-darkest)
    stack(
      slot(
        inset: 0.5em, fill: mk-header-color(self),
        align(left, heading(level: 3, text(fill: self.colors.neutral-lightest, weight: "regular")[#title]))
      ),
      slot(
        inset: (x: 0.6em, y: 0.75em),
        fill: self.colors.neutral-lighter.lighten(50%), align(left, body)
      )
    )
  })

  (
    make_block_fn(self => self.colors.primary),
    make_block_fn(self => self.colors.secondary),
    make_block_fn(self => self.colors.tertiary),
  )
}
