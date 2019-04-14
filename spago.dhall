{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name =
    "repository-list"
, dependencies =
    [ "bouzuya-http-client"
    , "console"
    , "debug"
    , "effect"
    , "node-process"
    , "optparse"
    , "psci-support"
    , "simple-json"
    , "test-unit"
    ]
, packages =
    ./packages.dhall
}
