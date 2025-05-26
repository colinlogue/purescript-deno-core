module Test.Main where

import Prelude

import Effect (Effect)
import Test.Spec.Reporter (consoleReporter)
import Test.Spec.Runner.Deno (runSpecAndExitProcess)
import Test.Deno.FileSystem as Test.Deno.FileSystem
import Test.Deno.FileInfo as Test.FileInfo
import Test.Deno.FsFile as Test.FsFile
import Test.Deno.FsWatcher as Test.FsWatcher

main :: Effect Unit
main = runSpecAndExitProcess [ consoleReporter ] do
  Test.Deno.FileSystem.spec
  Test.FileInfo.spec
  Test.FsFile.spec
  Test.FsWatcher.spec