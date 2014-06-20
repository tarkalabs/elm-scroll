module Main where

import Scroll

main = asText <~ foldp (\dy m -> (if dy > m then dy else m )) 0 Scroll.deltaY