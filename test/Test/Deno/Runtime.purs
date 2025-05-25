module Test.Deno.Runtime where

import Prelude

import Data.String as String
import Deno (consoleSize) as Deno
import Deno.Runtime (chdir, cwd, execPath, addSignalListener, removeSignalListener) as Deno
import Deno.Runtime.Signal (Signal(..))
import Effect (Effect)
import Effect.Class (liftEffect)
import Effect.Ref as Ref
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldSatisfy, shouldEqual, shouldNotEqual)

foreign import stdoutIsTerminal :: Effect Boolean

spec :: Spec Unit
spec = do
  describe "Deno Runtime" do
    describe "Basic system information" do
      it "should get current working directory" do
        cwd <- liftEffect Deno.cwd
        cwd `shouldSatisfy` (\s -> String.length s > 0)

      it "should get executable path" do
        execPath <- liftEffect Deno.execPath
        execPath `shouldSatisfy` String.contains (String.Pattern "deno")

      it "should get console size" do
        liftEffect stdoutIsTerminal >>= flip when do
          size <- liftEffect Deno.consoleSize
          size.columns `shouldSatisfy` (_ > 0)
          size.rows `shouldSatisfy` (_ > 0)

    describe "Directory operations" do
      it "should change working directory" do
        -- Test that we can change to /tmp and back
        originalCwd <- liftEffect Deno.cwd
        liftEffect $ Deno.chdir "/tmp"
        newCwd <- liftEffect Deno.cwd
        newCwd `shouldNotEqual` originalCwd

        -- Change back
        liftEffect $ Deno.chdir originalCwd
        finalCwd <- liftEffect Deno.cwd
        finalCwd `shouldEqual` originalCwd

    describe "Signal handling" do
      it "should handle SIGINT signal listener" do
        -- Test adding and removing SIGINT listener (supported on all platforms)
        handlerCalled <- liftEffect $ Ref.new false

        let handler = Ref.write true handlerCalled

        liftEffect $ Deno.addSignalListener SIGINT handler
        liftEffect $ Deno.removeSignalListener SIGINT handler

        pure unit
