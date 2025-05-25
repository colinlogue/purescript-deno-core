module Test.Deno.Command where

import Prelude

import Data.ArrayBuffer.Types (Uint8Array)
import Data.Maybe (Maybe(..))
import Data.String as String
import Deno.ChildProcess as ChildProcess
import Deno.Command as Command
import Deno.CommandOptions as CommandOptions
import Deno.Signal (Signal(..))
import Effect (Effect)
import Effect.Class (liftEffect)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual, shouldSatisfy)

-- Helper function to decode Uint8Array to String for testing
foreign import decodeText :: Uint8Array -> String

foreign import setEnvVar :: String -> String -> Effect Unit

spec :: Spec Unit
spec = do
  describe "Command" do
    describe "Command creation" do
      it "should create a command with empty options" do
        -- Just verify the command was created without throwing

        void $ liftEffect $ Command.new CommandOptions.empty "echo"

      it "should create a command with arguments" do
        let opts = CommandOptions.args ["hello", "world"]
        void $ liftEffect $ Command.new opts "echo"

      it "should create a command with cwd option" do
        let opts = CommandOptions.cwd "/tmp"
        void $ liftEffect $ Command.new opts "pwd"

      it "should create a command with environment variables" do
        let opts = CommandOptions.env { "TEST_VAR": "test_value", "ANOTHER_VAR": "another_value" }
        void $ liftEffect $ Command.new opts "env"

      it "should create a command with uid/gid options" do
        let opts = CommandOptions.uid 1000 <> CommandOptions.gid 1000
        void $ liftEffect $ Command.new opts "id"

      it "should create a command with clearEnv option" do
        let opts = CommandOptions.clearEnv true
        void $ liftEffect $ Command.new opts "env"

      it "should create a command with windowsRawArguments option" do
        let opts = CommandOptions.windowsRawArguments true
        void $ liftEffect $ Command.new opts "echo"

    describe "Stdio options" do
      it "should create a command with piped stdin" do
        let opts = CommandOptions.stdin CommandOptions.Piped
        void $ liftEffect $ Command.new opts "cat"

      it "should create a command with inherit stdin" do
        let opts = CommandOptions.stdin CommandOptions.Inherit
        void $ liftEffect $ Command.new opts "cat"

      it "should create a command with null stdin" do
        let opts = CommandOptions.stdin CommandOptions.Null
        void $ liftEffect $ Command.new opts "cat"

      it "should create a command with piped stdout" do
        let opts = CommandOptions.stdout CommandOptions.Piped
        void $ liftEffect $ Command.new opts "echo"

      it "should create a command with inherit stdout" do
        let opts = CommandOptions.stdout CommandOptions.Inherit
        void $ liftEffect $ Command.new opts "echo"

      it "should create a command with null stdout" do
        let opts = CommandOptions.stdout CommandOptions.Null
        void $ liftEffect $ Command.new opts "echo"

      it "should create a command with piped stderr" do
        let opts = CommandOptions.stderr CommandOptions.Piped
        void $ liftEffect $ Command.new opts "echo"

      it "should create a command with inherit stderr" do
        let opts = CommandOptions.stderr CommandOptions.Inherit
        void $ liftEffect $ Command.new opts "echo"

      it "should create a command with null stderr" do
        let opts = CommandOptions.stderr CommandOptions.Null
        void $ liftEffect $ Command.new opts "echo"

    describe "Combined options" do
      it "should create a command with multiple options combined" do
        let opts = CommandOptions.args ["test"]
                <> CommandOptions.cwd "/tmp"
                <> CommandOptions.stdout CommandOptions.Piped
                <> CommandOptions.stderr CommandOptions.Piped
                <> CommandOptions.env { "TEST_ENV": "value" }
        void $ liftEffect $ Command.new opts "echo"
        pure unit

    describe "Command output - async" do
      it "should run echo command and capture output asynchronously" do
        let opts = CommandOptions.args ["hello", "async"]
                <> CommandOptions.stdout CommandOptions.Piped
                <> CommandOptions.stderr CommandOptions.Piped
        cmd <- liftEffect $ Command.new opts "echo"
        result <- Command.output cmd

        let stdout = decodeText result.stdout
        stdout `shouldSatisfy` String.contains (String.Pattern "hello async")

      it "should capture stderr output asynchronously" do
        let opts = CommandOptions.args ["nonexistent_file"]
                <> CommandOptions.stdout CommandOptions.Piped
                <> CommandOptions.stderr CommandOptions.Piped
        cmd <- liftEffect $ Command.new opts "cat"
        result <- Command.output cmd

        let stderr = decodeText result.stderr
        -- stderr should contain some error message about the file not existing
        stderr `shouldSatisfy` (\s -> String.length s > 0)

      it "should run command with environment variables asynchronously" do
        let opts = CommandOptions.args ["-c", "echo $TEST_VAR"]
                <> CommandOptions.stdout CommandOptions.Piped
                <> CommandOptions.stderr CommandOptions.Piped
                <> CommandOptions.env { "TEST_VAR": "hello_env" }
        cmd <- liftEffect $ Command.new opts "sh"
        result <- Command.output cmd

        let stdout = decodeText result.stdout
        stdout `shouldSatisfy` String.contains (String.Pattern "hello_env")

      it "should run command with working directory asynchronously" do
        let opts = CommandOptions.cwd "/tmp"
                <> CommandOptions.stdout CommandOptions.Piped
                <> CommandOptions.stderr CommandOptions.Piped
        cmd <- liftEffect $ Command.new opts "pwd"
        result <- Command.output cmd

        let stdout = decodeText result.stdout
        stdout `shouldSatisfy` String.contains (String.Pattern "/tmp")

      it "should handle empty command output asynchronously" do
        let opts = CommandOptions.args ["-c", "true"]
                <> CommandOptions.stdout CommandOptions.Piped
                <> CommandOptions.stderr CommandOptions.Piped
        cmd <- liftEffect $ Command.new opts "sh"
        result <- Command.output cmd

        let stdout = decodeText result.stdout
        let stderr = decodeText result.stderr
        -- true command should produce no output
        stdout `shouldEqual` ""
        stderr `shouldEqual` ""

    describe "Command output - sync" do
      it "should run echo command and capture output synchronously" do
        let opts = CommandOptions.args ["hello", "sync"]
                <> CommandOptions.stdout CommandOptions.Piped
                <> CommandOptions.stderr CommandOptions.Piped
        cmd <- liftEffect $ Command.new opts "echo"
        result <- liftEffect $ Command.outputSync cmd

        let stdout = decodeText result.stdout
        stdout `shouldSatisfy` String.contains (String.Pattern "hello sync")

      it "should capture stderr output synchronously" do
        let opts = CommandOptions.args ["nonexistent_file_sync"]
                <> CommandOptions.stdout CommandOptions.Piped
                <> CommandOptions.stderr CommandOptions.Piped
        cmd <- liftEffect $ Command.new opts "cat"
        result <- liftEffect $ Command.outputSync cmd

        let stderr = decodeText result.stderr
        -- stderr should contain some error message
        stderr `shouldSatisfy` (\s -> String.length s > 0)

      it "should run command with environment variables synchronously" do
        let opts = CommandOptions.args ["-c", "echo $TEST_VAR_SYNC"]
                <> CommandOptions.stdout CommandOptions.Piped
                <> CommandOptions.stderr CommandOptions.Piped
                <> CommandOptions.env { "TEST_VAR_SYNC": "hello_env_sync" }
        cmd <- liftEffect $ Command.new opts "sh"
        result <- liftEffect $ Command.outputSync cmd

        let stdout = decodeText result.stdout
        stdout `shouldSatisfy` String.contains (String.Pattern "hello_env_sync")

      it "should run command with working directory synchronously" do
        let opts = CommandOptions.cwd "/tmp"
                <> CommandOptions.stdout CommandOptions.Piped
                <> CommandOptions.stderr CommandOptions.Piped
        cmd <- liftEffect $ Command.new opts "pwd"
        result <- liftEffect $ Command.outputSync cmd

        let stdout = decodeText result.stdout
        stdout `shouldSatisfy` String.contains (String.Pattern "/tmp")

      it "should handle empty command output synchronously" do
        let opts = CommandOptions.args ["-c", "true"]
                <> CommandOptions.stdout CommandOptions.Piped
                <> CommandOptions.stderr CommandOptions.Piped
        cmd <- liftEffect $ Command.new opts "sh"
        result <- liftEffect $ Command.outputSync cmd

        let stdout = decodeText result.stdout
        let stderr = decodeText result.stderr
        -- true command should produce no output
        stdout `shouldEqual` ""
        stderr `shouldEqual` ""

    describe "Command output comparison" do
      it "should produce consistent results between async and sync methods" do
        let opts = CommandOptions.args ["consistent_test"]
                <> CommandOptions.stdout CommandOptions.Piped
                <> CommandOptions.stderr CommandOptions.Piped

        -- Test async version
        cmdAsync <- liftEffect $ Command.new opts "echo"
        resultAsync <- Command.output cmdAsync

        -- Test sync version
        cmdSync <- liftEffect $ Command.new opts "echo"
        resultSync <- liftEffect $ Command.outputSync cmdSync

        let stdoutAsync = decodeText resultAsync.stdout
        let stdoutSync = decodeText resultSync.stdout
        let stderrAsync = decodeText resultAsync.stderr
        let stderrSync = decodeText resultSync.stderr

        -- Both should produce the same output
        stdoutAsync `shouldEqual` stdoutSync
        stderrAsync `shouldEqual` stderrSync

    describe "Advanced command scenarios" do
      it "should handle commands with clearEnv" do

        -- Set an environment variable to test clearEnv behavior
        void $ liftEffect $ setEnvVar "MY_VAR" "my_value"

        let opts = CommandOptions.args ["-c", "echo $MY_VAR"]
                <> CommandOptions.stdout CommandOptions.Piped
                <> CommandOptions.stderr CommandOptions.Piped
                <> CommandOptions.clearEnv true
        cmd <- liftEffect $ Command.new opts "/bin/sh"
        result <- Command.output cmd

        let stdout = decodeText result.stdout
        -- With clearEnv, PATH should be empty/undefined
        stdout `shouldSatisfy` (\s -> s == "" || s == "\n")

      it "should handle commands with specific environment override" do
        let opts = CommandOptions.args ["-c", "echo $CUSTOM_VAR"]
                <> CommandOptions.stdout CommandOptions.Piped
                <> CommandOptions.stderr CommandOptions.Piped
                <> CommandOptions.clearEnv true
                <> CommandOptions.env { "CUSTOM_VAR": "custom_value" }
        cmd <- liftEffect $ Command.new opts "/bin/sh"
        result <- Command.output cmd

        let stdout = decodeText result.stdout
        stdout `shouldSatisfy` String.contains (String.Pattern "custom_value")

      it "should handle long output from commands" do
        let opts = CommandOptions.args ["-c", "i=1; while [ $i -le 100 ]; do echo \"Line $i\"; i=$((i+1)); done"]
                <> CommandOptions.stdout CommandOptions.Piped
                <> CommandOptions.stderr CommandOptions.Piped
        cmd <- liftEffect $ Command.new opts "sh"
        result <- Command.output cmd

        let stdout = decodeText result.stdout
        stdout `shouldSatisfy` String.contains (String.Pattern "Line 1")
        stdout `shouldSatisfy` String.contains (String.Pattern "Line 100")

      it "should handle commands that write to both stdout and stderr" do
        let opts = CommandOptions.args ["-c", "echo 'to stdout'; echo 'to stderr' >&2"]
                <> CommandOptions.stdout CommandOptions.Piped
                <> CommandOptions.stderr CommandOptions.Piped
        cmd <- liftEffect $ Command.new opts "sh"
        result <- Command.output cmd

        let stdout = decodeText result.stdout
        let stderr = decodeText result.stderr
        stdout `shouldSatisfy` String.contains (String.Pattern "to stdout")
        stderr `shouldSatisfy` String.contains (String.Pattern "to stderr")

    describe "spawn" do
      it "should spawn a child process and return a valid pid" do
        let opts = CommandOptions.empty
        cmd <- liftEffect $ Command.new opts "echo"
        childProcess <- liftEffect $ Command.spawn cmd
        let pid = ChildProcess.pid childProcess
        pid `shouldSatisfy` (_ > 0)

      it "should wait for child process status" do
        let opts = CommandOptions.args ["hello", "world"]
        cmd <- liftEffect $ Command.new opts "echo"
        childProcess <- liftEffect $ Command.spawn cmd
        status <- ChildProcess.status childProcess

        -- The echo command should succeed
        status.success `shouldEqual` true
        status.code `shouldEqual` 0
        -- For a normal exit, signal should be Nothing
        status.signal `shouldEqual` Nothing

      it "should access stdin, stdout, and stderr streams of spawned process" do
        let opts = CommandOptions.stdout CommandOptions.Piped
                <> CommandOptions.stderr CommandOptions.Piped
                <> CommandOptions.stdin CommandOptions.Piped
        cmd <- liftEffect $ Command.new opts "echo"
        childProcess <- liftEffect $ Command.spawn cmd

        -- Test that we can access the streams
        void $ liftEffect $ ChildProcess.stdin childProcess
        void $ liftEffect $ ChildProcess.stdout childProcess
        void $ liftEffect $ ChildProcess.stderr childProcess

        -- Just verify the streams were created (they should be non-null for piped streams)
        pure unit

      it "should handle command that writes to stderr" do
        let opts = CommandOptions.stdout CommandOptions.Piped
                <> CommandOptions.stderr CommandOptions.Piped
                <> CommandOptions.args ["-c", "echo 'error message' >&2; exit 1"]
        cmd <- liftEffect $ Command.new opts "sh"
        childProcess <- liftEffect $ Command.spawn cmd

        status <- ChildProcess.status childProcess

        -- Command should fail
        status.success `shouldEqual` false
        status.code `shouldEqual` 1
        status.signal `shouldEqual` Nothing

      it "should spawn a long-running command and get its pid" do
        let opts = CommandOptions.stdout CommandOptions.Piped
                <> CommandOptions.stderr CommandOptions.Piped
                <> CommandOptions.args ["-c", "sleep 0.1; echo done"]
        cmd <- liftEffect $ Command.new opts "sh"
        childProcess <- liftEffect $ Command.spawn cmd

        let pid = ChildProcess.pid childProcess
        pid `shouldSatisfy` (_ > 0)

        -- Wait for it to complete
        status <- ChildProcess.status childProcess
        status.success `shouldEqual` true

      it "should kill a child process without a signal" do
        let opts = CommandOptions.stdout CommandOptions.Piped
                <> CommandOptions.stderr CommandOptions.Piped
                <> CommandOptions.args ["-c", "sleep 10"]  -- Long running command
        cmd <- liftEffect $ Command.new opts "sh"
        childProcess <- liftEffect $ Command.spawn cmd

        let pid = ChildProcess.pid childProcess
        pid `shouldSatisfy` (_ > 0)

        -- Kill the process without specifying a signal
        void $ liftEffect $ ChildProcess.kill Nothing childProcess

        -- Wait for it to exit
        status <- ChildProcess.status childProcess
        status.success `shouldEqual` false

      it "should kill a child process with SIGTERM signal" do
        let opts = CommandOptions.stdout CommandOptions.Piped
                <> CommandOptions.stderr CommandOptions.Piped
                <> CommandOptions.args ["-c", "sleep 10"]  -- Long running command
        cmd <- liftEffect $ Command.new opts "sh"
        childProcess <- liftEffect $ Command.spawn cmd

        let pid = ChildProcess.pid childProcess
        pid `shouldSatisfy` (_ > 0)

        -- Kill the process with SIGTERM
        void $ liftEffect $ ChildProcess.kill (Just SIGTERM) childProcess

        -- Wait for it to exit
        status <- ChildProcess.status childProcess
        status.success `shouldEqual` false
        -- On Unix systems, SIGTERM should be reported in the signal field
        status.signal `shouldSatisfy` (_ == Just SIGTERM)

      it "should kill a child process with SIGKILL signal" do
        let opts = CommandOptions.stdout CommandOptions.Piped
                <> CommandOptions.stderr CommandOptions.Piped
                <> CommandOptions.args ["-c", "sleep 10"]  -- Long running command
        cmd <- liftEffect $ Command.new opts "sh"
        childProcess <- liftEffect $ Command.spawn cmd

        let pid = ChildProcess.pid childProcess
        pid `shouldSatisfy` (_ > 0)

        -- Kill the process with SIGKILL
        void $ liftEffect $ ChildProcess.kill (Just SIGKILL) childProcess

        -- Wait for it to exit
        status <- ChildProcess.status childProcess
        status.success `shouldEqual` false
        -- SIGKILL should be reported in the signal field
        status.signal `shouldSatisfy` (_ == Just SIGKILL)

      it "should get output from a child process using output method" do
        let opts = CommandOptions.stdout CommandOptions.Piped
                <> CommandOptions.stderr CommandOptions.Piped
                <> CommandOptions.args ["hello world"]
        cmd <- liftEffect $ Command.new opts "echo"
        childProcess <- liftEffect $ Command.spawn cmd

        -- Get the output using the output method
        result <- ChildProcess.output childProcess

        -- Check the output
        let stdoutText = decodeText result.stdout
        stdoutText `shouldSatisfy` String.contains (String.Pattern "hello world")
        result.success `shouldEqual` true
        result.code `shouldEqual` 0
        result.signal `shouldEqual` Nothing

      it "should capture stderr in output method" do
        let opts = CommandOptions.stdout CommandOptions.Piped
                <> CommandOptions.stderr CommandOptions.Piped
                <> CommandOptions.args ["-c", "echo 'error message' >&2; exit 1"]
        cmd <- liftEffect $ Command.new opts "sh"
        childProcess <- liftEffect $ Command.spawn cmd

        -- Get the output using the output method
        result <- ChildProcess.output childProcess

        -- Check stderr output and exit code
        let stderrText = decodeText result.stderr
        stderrText `shouldSatisfy` String.contains (String.Pattern "error message")
        result.success `shouldEqual` false
        result.code `shouldEqual` 1
        result.signal `shouldEqual` Nothing

      it "should call ref method without errors" do
        let opts = CommandOptions.stdout CommandOptions.Piped
                <> CommandOptions.stderr CommandOptions.Piped
                <> CommandOptions.args ["Hello, ref test!"]
        cmd <- liftEffect $ Command.new opts "echo"
        childProcess <- liftEffect $ Command.spawn cmd

        -- Call ref method - should not throw
        void $ liftEffect $ ChildProcess.ref childProcess

        -- Wait for process to complete and verify it still works
        result <- ChildProcess.status childProcess
        result.success `shouldEqual` true

      it "should call unref method without errors" do
        let opts = CommandOptions.stdout CommandOptions.Piped
                <> CommandOptions.stderr CommandOptions.Piped
                <> CommandOptions.args ["Hello, unref test!"]
        cmd <- liftEffect $ Command.new opts "echo"
        childProcess <- liftEffect $ Command.spawn cmd

        -- Call unref method - should not throw
        void $ liftEffect $ ChildProcess.unref childProcess

        -- Wait for process to complete and verify it still works
        result <- ChildProcess.status childProcess
        result.success `shouldEqual` true

      it "should call ref and unref in sequence without errors" do
        let opts = CommandOptions.stdout CommandOptions.Piped
                <> CommandOptions.stderr CommandOptions.Piped
                <> CommandOptions.args ["Hello, ref/unref sequence test!"]
        cmd <- liftEffect $ Command.new opts "echo"
        childProcess <- liftEffect $ Command.spawn cmd

        -- Call ref then unref - should not throw
        void $ liftEffect $ ChildProcess.ref childProcess
        void $ liftEffect $ ChildProcess.unref childProcess

        -- Wait for process to complete and verify it still works
        result <- ChildProcess.status childProcess
        result.success `shouldEqual` true
