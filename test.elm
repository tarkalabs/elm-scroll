module Main where

import Scroll
import Mouse
import Window

type Position = { x : Float, y : Float }
type Dimensions = { width : Float, height : Float }

type Scene =
    { form : Form
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
    let zoomed = zoom update oldScene
    in  pan update zoomed


zoom : Update -> Scene -> Scene
zoom update oldScene =
    let scaleFactor = (1.1) ^ update.scrollDelta
    in { oldScene | form <- scale scaleFactor oldScene.form}

pan : Update -> Scene -> Scene
pan update oldScene =
    let zoomDirection = if update.scrollDelta >= 0 then -1 else 1
        adjustedMouse = { x = (min update.mouse.x update.window.width) - update.window.width/2
                        , y = update.window.height/2 - (min update.mouse.y update.window.height)
                        }
        panTo mouse = { x = zoomDirection * 0.02 * (mouse.x - oldScene.center.x)
                      , y = zoomDirection * 0.02 * (mouse.y - oldScene.center.y)
                      }
        newCenter = panTo adjustedMouse
    in  { oldScene |
          form <- move (newCenter.x, newCenter.y) oldScene.form
        , center <- newCenter}


emptyScene : Scene
emptyScene =
    let text = toText "Hipster Ipsum" |> typeface ["Futura"] |> leftAligned |> toForm
        budapestMap = image 500 500 "budapest.jpg" |> toForm
    in  { form = budapestMap
        , center = { x = 0, y = 0 }
        }


main = let floatify (a,b) = (toFloat a, toFloat b)
           mutedMouse = sampleOn Scroll.delta Mouse.position
           mousePosition = lift (\x -> uncurry Position <| floatify x) mutedMouse
           windowDimensions = lift (\x -> uncurry Dimensions <| floatify x) Window.dimensions
           updateRecord = lift3 Update Scroll.delta mousePosition windowDimensions
           scene = foldp updateScene emptyScene updateRecord
       in  lift2 (\s (w,h) -> collage w h [s.form]) scene Window.dimensions
