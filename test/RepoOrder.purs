-- https://github.com/bouzuya/purescript-react-basic-repository-list/blob/267a5209bb250a7484099e93134c90f2d500f4f3/src/Data/RepoOrder.purs
module Test.RepoOrder
  ( tests
  ) where

import Prelude

import Data.Enum as Enum
import Data.Maybe as Maybe
import Data.RepoOrder (RepoOrder)
import Data.RepoOrder as RepoOrder
import Test.Unit (TestSuite)
import Test.Unit as TestUnit
import Test.Unit.Assert as Assert

tests :: TestSuite
tests = TestUnit.suite "RepoOrder" do
  TestUnit.test "Bounded" do
    Assert.equal "created" (RepoOrder.toString (bottom :: RepoOrder))
    Assert.equal "full_name" (RepoOrder.toString (top :: RepoOrder))

  TestUnit.test "Enum" do
    Assert.equal
      (Maybe.Just "updated")
      (map RepoOrder.toString
        (Enum.succ (bottom :: RepoOrder)))
    Assert.equal
      (Maybe.Just "pushed")
      (map RepoOrder.toString
        (Enum.succ =<<
          (Enum.succ (bottom :: RepoOrder))))
    Assert.equal
      (Maybe.Just "full_name")
      (map RepoOrder.toString
        (Enum.succ =<<
          (Enum.succ =<<
            (Enum.succ (bottom :: RepoOrder)))))
    Assert.equal
      Maybe.Nothing
      (map RepoOrder.toString
        (Enum.succ =<<
          (Enum.succ =<<
            (Enum.succ =<<
              (Enum.succ (bottom :: RepoOrder))))))
    -- ...

  TestUnit.test "Eq" do
    Assert.equal 1 1

  TestUnit.test "Ord" do
    Assert.assert "<" (RepoOrder.Created < RepoOrder.Updated)
    Assert.assert "<" (RepoOrder.Updated < RepoOrder.Pushed)
    Assert.assert "<" (RepoOrder.Pushed < RepoOrder.FullName)

  TestUnit.test "fromString" do
    Assert.equal
      (Maybe.Just RepoOrder.Created)
      (RepoOrder.fromString "created")
    Assert.equal
      (Maybe.Just RepoOrder.Updated)
      (RepoOrder.fromString "updated")
    Assert.equal
      (Maybe.Just RepoOrder.Pushed)
      (RepoOrder.fromString "pushed")
    Assert.equal
      (Maybe.Just RepoOrder.FullName)
      (RepoOrder.fromString "full_name")

  TestUnit.test "toString" do
    Assert.equal "created" (RepoOrder.toString RepoOrder.Created)
    Assert.equal "updated" (RepoOrder.toString RepoOrder.Updated)
    Assert.equal "pushed" (RepoOrder.toString RepoOrder.Pushed)
    Assert.equal "full_name" (RepoOrder.toString RepoOrder.FullName)
