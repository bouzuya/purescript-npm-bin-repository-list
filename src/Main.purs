module Main
  ( main
  ) where

import Prelude

import Data.Array as Array
import Data.Maybe (Maybe)
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

booleanFromString :: String -> Maybe Boolean
booleanFromString =
  case _ of
    "true" -> Maybe.Just true
    "false" -> Maybe.Just false
    _ -> Maybe.Nothing

main :: Effect Unit
main = Aff.launchAff_ do
  options <- Class.liftEffect Options.parse
  let archived = booleanFromString options.archived
  count <- Fetch.fetchRepositoryCount options.username
  repos <-
    Array.foldRecM
      (\acc page -> do
        r <- Fetch.fetchRepos options 100 page
        pure (acc <> r))
      []
      (Array.range 1 ((count / 100) + 1))
  let
    filtered =
      Maybe.maybe
        repos
        (\b -> Array.filter ((eq b) <<< _.archived) repos)
        archived
  Class.liftEffect (Console.log (format filtered))
