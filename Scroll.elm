module Scroll where

import Native.Scroll
import Signal (Signal)

{-| How the scroll value changes (dx, dy) -}
delta : Signal Float
delta = Native.Scroll.delta