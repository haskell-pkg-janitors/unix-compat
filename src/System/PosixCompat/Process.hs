{-# LANGUAGE CPP #-}

{-|
This module intends to make the operations of @System.Posix.Process@ available
on all platforms.
-}
module System.PosixCompat.Process (
      getProcessID
    ) where

#ifdef mingw32_HOST_OS

import System.Posix.Types (ProcessID)
import System.Win32.Process (getCurrentProcessId)

getProcessID :: IO ProcessID
getProcessID = fromIntegral <$> getCurrentProcessId

#else

import System.Posix.Process

#endif
