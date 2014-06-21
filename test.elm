module Main where

import Scroll
import Mouse

sceneX : Int
sceneX = 500
sceneY : Int
sceneY = 500

updateScene : Float -> Form -> Form
updateScene zoom scene =
    let scaleFactor = (1.1) ^ zoom
    in  scale scaleFactor scene

pan : (Int,Int) -> Form -> Form
pan (mx, my) scene =
    let adjustedMouse = ( toFloat (min mx sceneX)- toFloat sceneX/2
                        , toFloat (-1 * (min my sceneY)) + toFloat sceneY/2)
    in  move adjustedMouse scene

emptyScene : Form
emptyScene = circle 20 |> filled red
                       |> move (0,0)


--main = lift asText Scroll.delta
main = lift2 (\x m -> collage sceneX sceneY [pan m x])
       (foldp updateScene emptyScene Scroll.delta)
       Mouse.position