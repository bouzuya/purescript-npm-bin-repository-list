module Main
  ( main
  ) where

import Prelude

import Data.Array as Array
import Data.Foldable as Foldable
import Data.Maybe as Maybe
import Data.Nullable as Nullable
import Data.String as String
import Data.Tuple as Tuple
import Effect (Effect)
import Effect.Aff as Aff
import Effect.Class as Class
import Effect.Class.Console as Console
import Fetch (Repo)
import Fetch as Fetch
import Options as Options

format :: Array Repo -> String
format repos = String.joinWith "\n" (map (formatLine maxLengths) formattedRepos)
  where
    formatLine :: Array Int -> Array String -> String
    formatLine ls xs =
      String.joinWith
        " "
        (map
          (\(Tuple.Tuple s l) -> padRight l s)
          (Array.zip xs ls))

    padRight :: Int -> String -> String
    padRight n s =
      s <> (String.joinWith "" (Array.replicate (n - (String.length s)) " "))

    formattedRepos :: Array (Array String)
    formattedRepos = map formatRepo repos

    maxLengths :: Array Int
    maxLengths = lengths formattedRepos

    lengths :: Array (Array String) -> Array Int
    lengths xs =
      Foldable.foldl
        (\a b -> Array.zipWith max a (map String.length b))
        (Array.replicate (Maybe.maybe 0 Array.length (Array.head xs)) 0)
        xs

    formatRepo :: Repo -> Array String
    formatRepo repo =
      [ repo.full_name
      , if repo.archived then "[Archived]" else ""
      , Maybe.fromMaybe "(null)" (Nullable.toMaybe repo.language)
      , (show repo.stargazers_count) <> " stars"
      ]

main :: Effect Unit
main = Aff.launchAff_ do
  options <- Class.liftEffect Options.parse
  repos <- Fetch.fetchRepos options 1
  Class.liftEffect (Console.log (format repos))
