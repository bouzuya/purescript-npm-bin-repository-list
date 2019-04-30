module Options
  ( Options
  , parse
  ) where

import Prelude

import Effect (Effect)
import Options.Applicative ((<**>))
import Options.Applicative as Options

type Options =
  { archived :: String
  , direction :: String
  , language :: String
  , sort :: String
  , type :: String
  , username :: String
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
  { archived: _
  , direction: _
  , language: _
  , sort: _
  , type: _
  , username: _
  , version: _
  }
    <$> Options.strOption
        ( Options.long "archived"
        <> Options.metavar "ARCHIVED"
        <> Options.help "filter archived/unarchived (true, false)" )
    <*> Options.strOption
        ( Options.long "direction"
        <> Options.showDefault
        <> (Options.value "asc")
        <> Options.metavar "DIRECTION"
        <> Options.help "direction (asc, desc)" )
    <*> Options.strOption
        ( Options.long "language"
        <> Options.metavar "LANGUAGE"
        <> Options.help "filter language (PureScript, ...)" )
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
    <*> Options.strOption
        ( Options.long "username"
        <> Options.metavar "USERNAME"
        <> Options.help "GitHub username" )
    <*> Options.switch
        ( Options.long "version"
        <> Options.short 'V'
        <> Options.help "Show version" )
