elm-scroll
==========

Mouse scroll support for Elm

## Try it!
Compile it with `elm test.elm --make`. Then open the file at `build/test.html`

## What you get
### Scroll.delta
What is this thing?
```haskell
delta : Signal Float
```
It should be a normalized value for scrolling across platforms and browsers. The normalization code mostly comes from Gavin Kistner at http://phrogz.net/JS/wheeldelta.html.

## Please report any unexpected experiences with scrolling.
If the scrolling feels far too slow or fast, let me know with a bug report. There are two ways to tune the scrolling. One is in userland and the other is under the hood with the normalization code.
