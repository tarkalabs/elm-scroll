module Main where

import Scroll
import Mouse
import Window
import Debug

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
updateScene = panZoom 


panZoom : Update -> Scene -> Scene
panZoom update oldScene =
    let scroll = (1.1) ^ update.scrollDelta
        centeredMouse = { x = (min update.mouse.x update.window.width) - update.window.width/2
                        , y = update.window.height/2 - (min update.mouse.y update.window.height)
                        }
        translationDiff pt1 pt2 = { dx = pt2.x - pt1.x
                                  , dy = pt2.y - pt1.y }
        translateOffset = Debug.log "offset" <| translationDiff oldScene.center centeredMouse
        centeredScene = move (translateOffset.dx,translateOffset.dy) oldScene.form
        zoomedScene = scale scroll centeredScene
    in { oldScene | form <- zoomedScene, center <- centeredMouse}

                

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
