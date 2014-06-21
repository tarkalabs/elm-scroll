module Main where

import Scroll
import Mouse

sceneX : Int
sceneX = 500
sceneY : Int
sceneY = 500

updateScene : Float -> Form -> Form
updateScene zoom scene =
    let scaleFactor = e ^ zoom
    in  scale scaleFactor scene


emptyScene : Form
emptyScene = circle 20 |> filled red
                       |> move (0,0)


--main = lift asText Scroll.delta
main = lift (\x -> collage sceneX sceneY [x]) <| foldp updateScene emptyScene Scroll.delta