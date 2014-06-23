module Scroll where
{-| Linear mouse scroll value, normalized across platforms.

# The signal
@docs delta
-}

import Native.Scroll
import Signal (Signal)

{-| How the scroll value changes as a delta. The value should be normalized
across browsers and platforms. Do not expect good mobile support though.
The number is unbounded but typical scrolling will stay between ±10. Also note
that the delta never becomes 0 once it has started. To combine this wil other
signals it is recommended that you use the `sampleOn` function

    let mutedMouse = sampleOn Scroll.delta Mouse.position
    in  lift2 (\x y -> asText <| (x,y)) Scroll.delta mutedMouse
-}
delta : Signal Float
delta = Native.Scroll.delta