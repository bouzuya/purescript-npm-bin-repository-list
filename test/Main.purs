module Test.Main where

import Prelude

import Effect (Effect)
import Test.RepoOrder as RepoOrder
import Test.Unit.Main as TestUnitMain

main :: Effect Unit
main = TestUnitMain.runTest do
  RepoOrder.tests
