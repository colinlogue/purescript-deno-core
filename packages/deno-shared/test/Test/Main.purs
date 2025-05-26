module Test.Main where

import Prelude

import Effect (Effect)
import Test.Spec.Reporter (consoleReporter)
import Test.Spec.Runner.Deno (runSpecAndExitProcess)
import Test.Web.Streams.WritableStream as Test.WritableStream

main :: Effect Unit
main = runSpecAndExitProcess [ consoleReporter ] do
  Test.WritableStream.spec