module Main
  ( main
  ) where

import Prelude

import Effect (Effect)
import Effect.Aff as Aff
import Effect.Class.Console as Console
import Fetch as Fetch
import Options as Options

main :: Effect Unit
main = do
  options <- Options.parse
  Console.logShow options
  Aff.launchAff_ (Fetch.fetchRepos options 1)
