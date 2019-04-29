module Main
  ( main
  ) where

import Prelude

import Data.Maybe as Maybe
import Data.Nullable as Nullable
import Effect (Effect)
import Effect.Aff as Aff
import Effect.Class as Class
import Effect.Class.Console as Console
import Fetch (Repo)
import Fetch as Fetch
import Options as Options
import Table as Table

format :: Array Repo -> String
format = Table.format <<< toTable
  where
    toTable :: Array Repo -> Array (Array String)
    toTable = map toRow

    toRow :: Repo -> Array String
    toRow repo =
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
