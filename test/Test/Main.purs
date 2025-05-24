module Test.Main where

import Prelude

import Effect (Effect)
import Effect.Class.Console (log)
import Test.Spec (describe, it)
import Test.Spec.Reporter (consoleReporter)
import Test.Spec.Runner.Deno (runSpecAndExitProcess)

main :: Effect Unit
main = runSpecAndExitProcess [ consoleReporter ] spec
  where
    spec = do
      describe "Test.Main" do
        it "should run the test suite" do
          log "Hello, world!"
