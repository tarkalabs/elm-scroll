module Main where

import Scroll
import Mouse
import Window
import Debug

type Position = { x : Float, y : Float }
type Dimensions = { width : Float, height : Float }

type Scene =
    { form : Form }

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
    let scroll = Debug.log "Scroll" <| (1.1) ^ update.scrollDelta
        mouse = { x = (min update.mouse.x update.window.width) - update.window.width/2
                , y = update.window.height/2 - (min update.mouse.y update.window.height)
                }
        diff pt1 pt2 = { dx = pt2.x - pt1.x
                       , dy = pt2.y - pt1.y
                       }

        offset = diff {x=0, y=0} mouse
        scaledOffset = { dx = offset.dx / scroll
                       , dy = offset.dy / scroll
                       }

        newScene = oldScene.form
                   |> move (Debug.log "move" (-offset.dx, -offset.dy))
                   |> scale scroll
                   |> move  (Debug.log "move back" (scaledOffset.dx, scaledOffset.dy))

    in  { oldScene | form <- newScene }        

emptyScene : Scene
emptyScene =
    let text = toText "Hipster Ipsum" |> typeface ["Futura"] |> leftAligned |> toForm
        budapestMap = image 500 500 "budapest.jpg" |> toForm
    in  { form = budapestMap }


main = let floatify (a,b) = (toFloat a, toFloat b)
           -- Get mouse position data only when you scroll
           mutedMouse = sampleOn Scroll.delta Mouse.position
           mousePosition = lift (\x -> uncurry Position <| floatify x) mutedMouse
           windowDimensions = lift (\x -> uncurry Dimensions <| floatify x) Window.dimensions
           --updateRecord = lift3 Update (always 0.1 <~ fps 30) mousePosition windowDimensions
           updateRecord = lift3 Update Scroll.delta mousePosition windowDimensions
           scene = foldp updateScene emptyScene updateRecord
       in  lift2 (\s (w,h) -> collage w h [s.form]) scene Window.dimensions
