module Options
  ( Options
  , parse
  ) where

import Prelude

import Effect (Effect)
import Options.Applicative ((<**>))
import Options.Applicative as Options

type Options =
  { direction :: String
  , sort :: String
  , type :: String
  , version :: Boolean
  }

parse :: Effect Options
parse = Options.execParser opts
  where
    opts = Options.info (parser <**> Options.helper)
      ( Options.fullDesc
     <> Options.progDesc "repository list"
     <> Options.header "repository-list - repository list" )

parser :: Options.Parser Options
parser =
  ({ direction: _, sort: _, type: _, version: _ })
    <$> Options.strOption
        ( Options.long "direction"
        <> Options.showDefault
        <> (Options.value "asc")
        <> Options.metavar "DIRECTION"
        <> Options.help "direction (asc, desc)" )
    <*> Options.strOption
        ( Options.long "sort"
        <> Options.showDefault
        <> (Options.value "full_name")
        <> Options.metavar "SORT"
        <> Options.help "sort (created, updated, pushed, full_name)" )
    <*> Options.strOption
        ( Options.long "type"
        <> Options.showDefault
        <> (Options.value "owner")
        <> Options.metavar "TYPE"
        <> Options.help "type (all, owner, member)" )
    <*> Options.switch
        ( Options.long "version"
        <> Options.short 'V'
        <> Options.help "Show version" )
