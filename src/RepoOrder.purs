module Data.RepoOrder
  ( RepoOrder(..)
  , fromString
  , toString
  ) where

import Prelude

import Data.Enum (class Enum)
import Data.Maybe (Maybe)
import Data.Maybe as Maybe

data RepoOrder
  = Created
  | Updated
  | Pushed
  | FullName

instance boundedRepoOrder :: Bounded RepoOrder where
  bottom = Created
  top = FullName

instance enumRepoOrder :: Enum RepoOrder where
  succ =
    case _ of
      Created -> Maybe.Just Updated
      Updated -> Maybe.Just Pushed
      Pushed -> Maybe.Just FullName
      FullName -> Maybe.Nothing
  pred =
    case _ of
      Created -> Maybe.Nothing
      Updated -> Maybe.Just Created
      Pushed -> Maybe.Just Updated
      FullName -> Maybe.Just Pushed

derive instance eqRepoOrder :: Eq RepoOrder

derive instance ordRepoOrder :: Ord RepoOrder

instance showRepoOrder :: Show RepoOrder where
  show =
    case _ of
      Created -> "created"
      Updated -> "updated"
      Pushed -> "pushed"
      FullName -> "full_name"

fromString :: String -> Maybe RepoOrder
fromString =
  case _ of
    "created" -> Maybe.Just Created
    "updated" -> Maybe.Just Updated
    "pushed" -> Maybe.Just Pushed
    "full_name" -> Maybe.Just FullName
    _ -> Maybe.Nothing

toString :: RepoOrder -> String
toString = show
