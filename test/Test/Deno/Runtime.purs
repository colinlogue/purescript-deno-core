module Test.Deno.Runtime where

import Prelude

import Data.String as String
import Deno (consoleSize) as Deno
import Deno.Runtime (chdir, cwd, execPath, loadavg, memoryUsage, addSignalListener, removeSignalListener, LoadAvgResult(..)) as Deno
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

      it "should get system load averages" do
        (Deno.LoadAvgResult min1 min5 min15) <- liftEffect Deno.loadavg
        -- Should return load averages for 1, 5, 15 minutes
        -- On Windows this returns [0, 0, 0], on Unix it should be non-negative numbers
        min1 `shouldSatisfy` (_ >= 0.0)
        min5 `shouldSatisfy` (_ >= 0.0)
        min15 `shouldSatisfy` (_ >= 0.0)

      it "should get memory usage information" do
        usage <- liftEffect Deno.memoryUsage
        -- Memory usage values should be non-negative numbers
        usage.rss `shouldSatisfy` (_ >= 0.0)
        usage.heapTotal `shouldSatisfy` (_ >= 0.0)
        usage.heapUsed `shouldSatisfy` (_ >= 0.0)
        usage.external `shouldSatisfy` (_ >= 0.0)
        -- heapUsed should not exceed heapTotal
        usage.heapUsed `shouldSatisfy` (_ <= usage.heapTotal)

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
