module Main where

import Scroll
import Mouse
import Window

type Position = { x : Float, y : Float }
type Dimensions = { width : Float, height : Float }

type Scene =
    { object : Form
    , center : Position
    }

type Update =
    { scrollDelta : Float
    , mouse : Position
    , window : Dimensions
    }

-- The idea is to pass aroud the center of the system along with the form too.
updateScene : Update -> Scene -> Scene
updateScene update oldScene =
    let scaleFactor = (1.01) ^ update.scrollDelta
        zoomDirection = if update.scrollDelta >= 0 then 1 else -1
        scaled = scale scaleFactor oldScene.object
        adjustedMouse = { x = (min update.mouse.x update.window.width) - update.window.width/2
                        , y = (-1 * (min update.mouse.y update.window.height)) + update.window.height/2
                        }
        direction mouse = { mouse |
                            x <- zoomDirection * 0.01 * (mouse.x - oldScene.center.x)
                          , y <- zoomDirection * 0.01 * (mouse.y - oldScene.center.y)
                          }
        newCenter = direction adjustedMouse
    in  { oldScene |
          object <- move (newCenter.x, newCenter.y) scaled
        , center <- newCenter}


emptyScene : Scene
emptyScene =
    let text = toText "Hipster Ipsum" |> typeface ["Futura"] |> leftAligned |> toForm
    in  { object = text
        , center = { x = 0, y = 0 }
        }


main = let floatify (a,b) = (toFloat a, toFloat b)
           mutedMouse = sampleOn Scroll.delta Mouse.position
           mousePosition = lift (\x -> uncurry Position <| floatify x) mutedMouse
           windowDimensions = lift (\x -> uncurry Dimensions <| floatify x) Window.dimensions
           updateRecord = lift3 Update Scroll.delta mousePosition windowDimensions
           scene = foldp updateScene emptyScene updateRecord
       in  lift2 (\s (w,h) -> collage w h [s.object]) scene Window.dimensions
