module Scroll where

import Native.Scroll
import Signal (Signal)

{-| How the scroll value changes (dx, dy) -}
scroll : Signal (Int, Int)
scroll = Native.scroll