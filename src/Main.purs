module Main
  ( main
  ) where

import Prelude

import Effect (Effect)
import Effect.Class.Console as Console
import Options as Options

main :: Effect Unit
main = do
  options <- Options.parse
  Console.logShow options
