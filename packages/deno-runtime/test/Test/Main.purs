module Test.Main where

import Prelude

import Effect (Effect)
import Test.Spec.Reporter (consoleReporter)
import Test.Spec.Runner.Deno (runSpecAndExitProcess)
import Test.Deno.Runtime as Test.Deno.Runtime

main :: Effect Unit
main = runSpecAndExitProcess [ consoleReporter ] do
  Test.Deno.Runtime.spec