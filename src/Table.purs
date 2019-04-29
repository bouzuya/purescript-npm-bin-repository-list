module Table
  ( format
  ) where

import Prelude

import Data.Array as Array
import Data.Foldable as Foldable
import Data.Maybe as Maybe
import Data.String as String
import Data.Tuple as Tuple

format :: Array (Array String) -> String
format table =
  String.joinWith "\n" (map (formatLine (maxLengths table)) table)
  where
    formatLine :: Array Int -> Array String -> String
    formatLine ls xs =
      String.joinWith
        " "
        (map
          (\(Tuple.Tuple s l) -> padRight l s)
          (Array.zip xs ls))

    maxLengths :: Array (Array String) -> Array Int
    maxLengths xs =
      Foldable.foldl
        (\a b -> Array.zipWith max a (map String.length b))
        (Array.replicate (Maybe.maybe 0 Array.length (Array.head xs)) 0)
        xs

    padRight :: Int -> String -> String
    padRight n s =
      s <> (String.joinWith "" (Array.replicate (n - (String.length s)) " "))
