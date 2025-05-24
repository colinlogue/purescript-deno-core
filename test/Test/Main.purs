module Test.Main where

import Prelude

import Effect (Effect)
import Test.Spec.Reporter (consoleReporter)
import Test.Spec.Runner.Deno (runSpecAndExitProcess)
import Test.Deno as Test.Deno

main :: Effect Unit
main = runSpecAndExitProcess [ consoleReporter ] Test.Deno.spec
