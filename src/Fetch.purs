module Fetch
  ( Repo
  , fetchRepos
  , fetchRepositoryCount
  ) where

import Prelude

import Bouzuya.HTTP.Client as HttpClient
import Bouzuya.HTTP.Method as Method
import Data.Either as Either
import Data.Maybe as Maybe
import Data.Nullable (Nullable)
import Data.Options ((:=))
import Data.RepoOrder as RepoOrder
import Data.String as String
import Data.Tuple as Tuple
import Effect.Aff (Aff)
import Effect.Aff as Aff
import Foreign.Object as Object
import Options (Options)
import Simple.JSON as SimpleJSON

type Repo =
  { archived :: Boolean
  , full_name :: String
  , language :: Nullable String
  , stargazers_count :: Int
  , updated_at :: String
  }

fetchRepos :: Options -> Int -> Aff (Array Repo)
fetchRepos options page = do
  order <-
    Maybe.maybe
      (Aff.throwError (Aff.error "unknown sort"))
      pure
      (RepoOrder.fromString options.sort)
  let
    baseUrl = "https://api.github.com"
    path = "/users/" <> options.username <> "/repos"
    query =
      String.joinWith
        "&"
        [ "type=" <> options.type
        , "sort=" <> RepoOrder.toString order
        , "direction=" <> options.direction
        , "per_page=100"
        , "page=" <> show page
        ]
    url = baseUrl <> path <> "?" <> query
  { body } <-
    HttpClient.fetch
      ( HttpClient.headers :=
        Object.fromFoldable [ Tuple.Tuple "User-Agent" "repository-list" ]
      <> HttpClient.method := Method.GET
      <> HttpClient.url := url
      )
  b <-
    Maybe.maybe
      (Aff.throwError (Aff.error "body is nothing"))
      pure
      body
  Either.either
    (Aff.throwError <<< Aff.error <<< show)
    pure
    (SimpleJSON.readJSON b :: _ (Array Repo))

fetchRepositoryCount :: String -> Aff Int
fetchRepositoryCount username = do
  let
    baseUrl = "https://api.github.com"
    path = "/users/" <> username
    url = baseUrl <> path
  { body } <-
    HttpClient.fetch
      ( HttpClient.headers :=
        Object.fromFoldable [ Tuple.Tuple "User-Agent" "repository-list" ]
      <> HttpClient.method := Method.GET
      <> HttpClient.url := url
      )
  b <-
    Maybe.maybe
      (Aff.throwError (Aff.error "body is nothing"))
      pure
      body
  Either.either
    (Aff.throwError <<< Aff.error <<< show)
    (pure <<< _.public_repos)
    (SimpleJSON.readJSON b :: _ ({ public_repos :: Int }))
