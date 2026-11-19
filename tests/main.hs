module Main where

import MkstempSpec
import LinksSpec
import LongPathsSpec
import ProcessSpec

import Test.Hspec

main :: IO ()
main = hspec $ do
    mkstempSpec
    linksSpec
    longPathsSpec
    processSpec
