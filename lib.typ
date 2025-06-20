#import "@preview/showybox:2.0.3": showybox

#let int(x) = $floor.l #x floor.r$


#let generalbox(color, title, text, ..opts) = {
  showybox(
    title-style: (
      weight: 900,
      color: color.darken(40%),
      sep-thickness: 0pt,
      align: center
    ),
    frame: (
      title-color: color.lighten(80%),
      border-color: color.darken(40%),
      body-color: color.lighten(90%),
      thickness: (left: 1pt),
      radius: (top-right: 5pt, bottom-right:5pt, rest: 0pt)
    ),
    title: title,
    text,
    ..opts
  )
}

// I'm so functional
#let bluebox(title, text, ..opts) = {
  generalbox(blue, title, text, ..opts)
}

#let pinkbox(title, text, ..opts) = {
  generalbox(fuchsia, title, text, ..opts)
}

#let Definitionbox(title, text, ..opts) = {
  let defTitle = "Definitions"
  if title != "" {
    defTitle = "Definition: " + title
  }
  generalbox(teal, defTitle, text, ..opts)
}

#let purplebox(title, text, ..opts) = {
  generalbox(purple, title, text, ..opts)
}

#let Examplebox(text, ..opts) = {
  generalbox(orange, "Example", text, ..opts)
}

#let Notationbox(text, ..opts) = {
  generalbox(green, "Notation", text, ..opts)
}

