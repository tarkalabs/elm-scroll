module Main where

import Scroll
import Mouse
import Window

-- The idea is to pass aroud the center of the system along with the form too.
updateScene : (Float,(Int,Int),(Int,Int)) -> (Form,(Int,Int)) -> (Form,(Int,Int))
updateScene (zoom,(mx,my),(wx,wy)) (scene,(cx,cy)) =
    let scaleFactor = (1.01) ^ zoom
        zoomDirection = if zoom >= 0 then 1 else -1
        mouseX = toFloat mx
        mouseY = toFloat my
        sceneX = toFloat wx
        sceneY = toFloat wy
        scaled = scale scaleFactor scene
        adjustedMouse = ( (toFloat (min mx wx) - sceneX/2)
                        , (toFloat (-1 * (min my wy)) + sceneY/2))
        --ad{x,y} = adjusted Mouse {x,y}
        direction (amx, amy) = ( zoomDirection * 0.01 * (amx - toFloat cx)
                               , zoomDirection * 0.01 * (amy - toFloat cy))
        newCenter = direction adjustedMouse
        intNewCenter = (\(x,y) -> (round x, round y)) newCenter
    in  (move newCenter scaled, intNewCenter)

emptyScene : (Form,(Int,Int))
emptyScene =
    let center = (0,0)
        text = toText "Hipster Ipsum" |> typeface ["Futura"] |> leftAligned |> toForm
    in (text, center)


main = let mutedMouse = (sampleOn Scroll.delta Mouse.position)
           mouseData = lift3 (\x y z -> (x,y,z)) Scroll.delta mutedMouse Window.dimensions
           scene = foldp updateScene emptyScene mouseData
       in  lift2 (\(s,_) (x,y) -> collage x y [s]) scene Window.dimensions
