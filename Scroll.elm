module Scroll where

import Native.Scroll
import Signal (Signal)

{-| How the scroll value changes (dx, dy) -}
deltaY : Signal Int
deltaY = Native.Scroll.deltaY