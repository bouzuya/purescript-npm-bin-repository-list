module Main
  ( main
  ) where

import Prelude

import Data.Maybe as Maybe
import Data.Nullable as Nullable
import Data.String as String
import Effect (Effect)
import Effect as Effect
import Effect.Aff as Aff
import Effect.Class as Class
import Effect.Class.Console as Console
import Fetch (Repo)
import Fetch as Fetch
import Options as Options

format :: Repo -> String
format repo =
  String.joinWith
    "\t"
    [ repo.full_name
    , Maybe.fromMaybe "(null)" (Nullable.toMaybe repo.language)
    , (show repo.stargazers_count) <> " stars"
    ]

main :: Effect Unit
main = Aff.launchAff_ do
  options <- Class.liftEffect Options.parse
  repos <- Fetch.fetchRepos options 1
  Class.liftEffect
    (Effect.foreachE repos \repo -> do
      Console.log (format repo))
