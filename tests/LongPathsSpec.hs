module LongPathsSpec(longPathsSpec) where

import Control.Exception ( finally )
import qualified System.Directory as D
import System.FilePath ( (</>) )
import System.IO.Temp
import System.PosixCompat
import Test.Hspec
import Test.HUnit

longPathsSpec :: Spec
longPathsSpec = do
  describe "getFileStatus" $ do
    it "should stat a directory and a file at absolute paths longer than MAX_PATH" $ do
      runInTempDir $ \tmp -> do
        let dir = foldl (</>) tmp (replicate 30 "directory")
            file = dir </> "file"
        D.createDirectoryIfMissing True dir
        writeFile file "contents"
        assert $ length file > 260

        dirStat <- getFileStatus dir
        assert $ isDirectory dirStat
        fileStat <- getFileStatus file
        assert $ isRegularFile fileStat
        fileSize fileStat @?= 8

    it "should stat relative paths and paths with .. longer than MAX_PATH" $ do
      runInTempDir $ \tmp -> do
        let rel = foldl (</>) "." (replicate 30 "directory")
            file = rel </> "file"
            dotted = tmp </> rel </> ".." </> "directory" </> "file"
        D.createDirectoryIfMissing True rel
        writeFile file "contents"
        assert $ length (tmp </> file) > 260

        relStat <- getFileStatus file
        assert $ isRegularFile relStat
        dottedStat <- getFileStatus dotted
        assert $ isRegularFile dottedStat

  where

    runInTempDir action = do
      orig <- D.getCurrentDirectory
      withTempDirectory orig "xxxxxxx" $ \tmp -> do
        D.setCurrentDirectory tmp
        action tmp `finally` D.setCurrentDirectory orig
