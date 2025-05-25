module Test.Main where

import Prelude

import Effect (Effect)
import Test.Spec.Reporter (consoleReporter)
import Test.Spec.Runner.Deno (runSpecAndExitProcess)
import Test.Deno as Test.Deno
import Test.Deno.Command as Test.Deno.Command
import Test.Deno.Runtime as Test.Deno.Runtime
import Test.Deno.FileInfo as Test.FileInfo
import Test.Deno.FsFile as Test.FsFile
import Test.Web.Streams.WritableStream as Test.WritableStream

main :: Effect Unit
main = runSpecAndExitProcess [ consoleReporter ] do
  Test.Deno.spec
  Test.Deno.Command.spec
  Test.Deno.Runtime.spec
  Test.FileInfo.spec
  Test.FsFile.spec
  Test.WritableStream.spec
