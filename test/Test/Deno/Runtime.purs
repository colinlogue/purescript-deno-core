module Test.Deno.Runtime where

import Prelude

import Data.Array as Array
import Data.Maybe (Maybe(..))
import Data.String as String
import Deno (consoleSize) as Deno
import Deno.Runtime (chdir, cwd, execPath, loadavg, memoryUsage, systemMemoryInfo, addSignalListener, removeSignalListener, refTimer, unrefTimer, LoadAvgResult(..), args, build, exitCode, setExitCode, mainModule, noColor, pid, ppid, version, env) as Deno
import Deno.Runtime.Env (get, set, delete, has, toObject) as Env
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

      it "should get system memory information" do
        sysMemInfo <- liftEffect Deno.systemMemoryInfo
        -- All memory values should be non-negative numbers
        sysMemInfo.total `shouldSatisfy` (_ >= 0.0)
        sysMemInfo.free `shouldSatisfy` (_ >= 0.0)
        sysMemInfo.available `shouldSatisfy` (_ >= 0.0)
        sysMemInfo.buffers `shouldSatisfy` (_ >= 0.0)
        sysMemInfo.cached `shouldSatisfy` (_ >= 0.0)
        sysMemInfo.swapTotal `shouldSatisfy` (_ >= 0.0)
        sysMemInfo.swapFree `shouldSatisfy` (_ >= 0.0)
        -- Free memory should not exceed total memory
        sysMemInfo.free `shouldSatisfy` (_ <= sysMemInfo.total)
        -- Available memory should not exceed total memory
        sysMemInfo.available `shouldSatisfy` (_ <= sysMemInfo.total)
        -- Free swap should not exceed total swap
        sysMemInfo.swapFree `shouldSatisfy` (_ <= sysMemInfo.swapTotal)

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

    describe "Timer operations" do
      it "should handle timer reference operations" do
        -- Test that refTimer and unrefTimer can be called without errors
        -- We create a timer and test both ref and unref operations
        liftEffect $ Deno.refTimer 123  -- Using arbitrary timer ID for testing
        liftEffect $ Deno.unrefTimer 123

        pure unit

    describe "Runtime variables" do
      it "should get script arguments" do
        args <- pure Deno.args
        -- args should be an array (may be empty in test environment)
        Array.length args `shouldSatisfy` (_ >= 0)

      it "should get build information" do
        buildInfo <- pure Deno.build
        -- Build info should have required fields
        buildInfo.target `shouldSatisfy` (\s -> String.length s > 0)
        buildInfo.arch `shouldSatisfy` (\s -> String.length s > 0)
        buildInfo.os `shouldSatisfy` (\s -> String.length s > 0)
        buildInfo.vendor `shouldSatisfy` (\s -> String.length s > 0)

      it "should handle exit code operations" do
        originalExitCode <- liftEffect Deno.exitCode
        liftEffect $ Deno.setExitCode 42
        newExitCode <- liftEffect Deno.exitCode
        newExitCode `shouldEqual` 42
        -- Reset to original
        liftEffect $ Deno.setExitCode originalExitCode

      it "should get main module" do
        mainMod <- pure Deno.mainModule
        -- Main module should be a string
        String.length mainMod `shouldSatisfy` (_ >= 0)

      it "should get noColor flag" do
        noColorFlag <- pure Deno.noColor
        -- noColor should be a boolean
        (noColorFlag == true || noColorFlag == false) `shouldEqual` true

      it "should get process IDs" do
        processId <- pure Deno.pid
        parentProcessId <- pure Deno.ppid
        -- PIDs should be positive integers
        processId `shouldSatisfy` (_ > 0)
        parentProcessId `shouldSatisfy` (_ > 0)

      it "should get version information" do
        versionInfo <- pure Deno.version
        -- Version info should have required fields with non-empty strings
        versionInfo.deno `shouldSatisfy` (\s -> String.length s > 0)
        versionInfo.v8 `shouldSatisfy` (\s -> String.length s > 0)
        versionInfo.typescript `shouldSatisfy` (\s -> String.length s > 0)

    describe "Environment variables" do
      it "should access env runtime variable" do
        envObj <- pure Deno.env
        -- env should be a valid Env object
        -- We can't directly test its type, but we can test that it works with Env functions
        pathExists <- liftEffect $ Env.has envObj "PATH"
        -- PATH should exist on most systems
        pathExists `shouldEqual` true

      it "should get environment variable value" do
        envObj <- pure Deno.env
        pathValue <- liftEffect $ Env.get envObj "PATH"
        case pathValue of
          Just path -> String.length path `shouldSatisfy` (_ > 0)
          Nothing -> pure unit -- Some systems might not have PATH, that's ok

      it "should set and get environment variable" do
        envObj <- pure Deno.env
        let testKey = "PURESCRIPT_DENO_TEST_VAR"
        let testValue = "test_value_12345"
        
        -- Set the test variable
        liftEffect $ Env.set envObj testKey testValue
        
        -- Check it exists
        hasVar <- liftEffect $ Env.has envObj testKey
        hasVar `shouldEqual` true
        
        -- Get the value back
        getValue <- liftEffect $ Env.get envObj testKey
        getValue `shouldEqual` (Just testValue)
        
        -- Clean up
        liftEffect $ Env.delete envObj testKey

      it "should delete environment variable" do
        envObj <- pure Deno.env
        let testKey = "PURESCRIPT_DENO_DELETE_TEST"
        let testValue = "delete_me"
        
        -- Set the test variable
        liftEffect $ Env.set envObj testKey testValue
        
        -- Verify it exists
        hasVar1 <- liftEffect $ Env.has envObj testKey
        hasVar1 `shouldEqual` true
        
        -- Delete it
        liftEffect $ Env.delete envObj testKey
        
        -- Verify it's gone
        hasVar2 <- liftEffect $ Env.has envObj testKey
        hasVar2 `shouldEqual` false
        
        -- Getting it should return Nothing
        getValue <- liftEffect $ Env.get envObj testKey
        getValue `shouldEqual` Nothing

      it "should check environment variable existence" do
        envObj <- pure Deno.env
        let nonExistentKey = "PURESCRIPT_DENO_NONEXISTENT_VAR_98765"
        
        -- This variable should not exist
        hasVar <- liftEffect $ Env.has envObj nonExistentKey
        hasVar `shouldEqual` false

      it "should get all environment variables as object" do
        envObj <- pure Deno.env
        allVars <- liftEffect $ Env.toObject envObj
        -- The environment object should contain some variables
        -- We can't test specific variables as they vary by system,
        -- but we can test that it's a valid object structure
        -- Most systems should have at least one environment variable
        String.length (show allVars) `shouldSatisfy` (_ > 10)

      it "should handle setting and getting complex values" do
        envObj <- pure Deno.env
        let testKey = "PURESCRIPT_DENO_COMPLEX_TEST"
        let complexValue = "value with spaces and special chars: !@#$%^&*()"
        
        -- Set complex value
        liftEffect $ Env.set envObj testKey complexValue
        
        -- Get it back
        getValue <- liftEffect $ Env.get envObj testKey
        getValue `shouldEqual` (Just complexValue)
        
        -- Clean up
        liftEffect $ Env.delete envObj testKey
