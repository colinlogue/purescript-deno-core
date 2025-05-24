module Test.Main where

import Prelude

import Deno as Deno
import Deno.FsFile (isTerminal)
import Effect (Effect)
import Effect.Aff.Class (liftAff)
import Effect.Class (liftEffect)
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
          file <- liftAff $ Deno.create "test.txt"
          isTerminalResult <- liftEffect $ isTerminal file
          log $ "Is terminal: " <> show isTerminalResult
