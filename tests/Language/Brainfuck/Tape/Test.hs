module Language.Brainfuck.Tape.Test (tapeSuite) where

import Language.Brainfuck.Tape
import qualified Data.List.Zipper as Z

import Test.Tasty ( TestTree
                  , testGroup
                  )

import Test.Tasty.QuickCheck ( Gen
                             , testProperty
                             , forAll
                             , suchThat
                             , arbitrary
                             )

import Test.Properties ( idempotent
                       , inverts
                       )

-- import qualified Test.Tasty.HUnit          as HU
-- import qualified Test.Tasty.SmallCheck     as SC
-- import qualified Test.QuickCheck.Instances as QI
-- import qualified Test.QuickCheck.Utils     as QU
-- import qualified Test.QuickCheck.Checkers  as Ch

tapeSuite :: TestTree
tapeSuite = testGroup "Tape"
  [ testProperty "`set` is idempotent" $
      idempotent . set
  , testProperty "`left` and `right` commute for all tapes" $
      forAll tapes $ commutes left right
  , testProperty "`left` and `right` invert for all tapes" $
      forAll tapes $ inverts left right
  ]

commutes :: Eq a => (a -> a) -> (a -> a) -> a -> Bool
commutes f g a = (f . g) a == (g . f) a

tapes :: Gen Tape
tapes = arbitrary `suchThat` minSubTape
  where minSubTape (Z.Zip a b) = length a > 2 && length b > 2
