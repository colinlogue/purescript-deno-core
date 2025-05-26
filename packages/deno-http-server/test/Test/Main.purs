module Test.Main where

import Prelude

import Effect (Effect)
import Test.Spec.Reporter (consoleReporter)
import Test.Spec.Runner.Deno (runSpecAndExitProcess)
import Test.Deno.HttpServer as Test.Deno.HttpServer

main :: Effect Unit
main = runSpecAndExitProcess [ consoleReporter ] do
  Test.Deno.HttpServer.spec