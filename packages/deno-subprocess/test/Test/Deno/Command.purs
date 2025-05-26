module Test.Deno.Command where

import Prelude

import Data.ArrayBuffer.Types (Uint8Array)
import Data.Maybe (Maybe(..))
import Data.String as String
import Deno.Runtime.Signal (Signal(..))
import Deno.Subprocess.ChildProcess as ChildProcess
import Deno.Subprocess.Command as Command
import Deno.Subprocess.CommandOptions as CommandOptions
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

      it "should create a command with args option" do
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
        void $ liftEffect $ Command.new opts "cmd"

      it "should create a command with I/O redirection options" do
        let opts = CommandOptions.stdout CommandOptions.Piped 
                <> CommandOptions.stderr CommandOptions.Piped
                <> CommandOptions.stdin CommandOptions.Piped
        void $ liftEffect $ Command.new opts "cat"

      it "should combine multiple options" do
        let opts = CommandOptions.args ["--version"]
                <> CommandOptions.stdout CommandOptions.Piped
                <> CommandOptions.stderr CommandOptions.Piped
                <> CommandOptions.stdin CommandOptions.Null
        void $ liftEffect $ Command.new opts "node"

    describe "Command execution" do
      it "should run command and get output asynchronously" do
        let opts = CommandOptions.args ["-c", "echo hello"]
                <> CommandOptions.stdout CommandOptions.Piped
                <> CommandOptions.stderr CommandOptions.Piped
        cmd <- liftEffect $ Command.new opts "sh"
        result <- Command.output cmd

        let stdout = decodeText result.stdout
        let stderr = decodeText result.stderr
        
        stdout `shouldSatisfy` String.contains (String.Pattern "hello")
        String.length stderr `shouldEqual` 0
        result.status.success `shouldEqual` true
        result.status.code `shouldEqual` 0

      it "should run command and get output synchronously" do
        let opts = CommandOptions.args ["-c", "echo hello sync"]
                <> CommandOptions.stdout CommandOptions.Piped
                <> CommandOptions.stderr CommandOptions.Piped
        cmd <- liftEffect $ Command.new opts "sh"
        result <- liftEffect $ Command.outputSync cmd

        let stdout = decodeText result.stdout
        let stderr = decodeText result.stderr
        
        stdout `shouldSatisfy` String.contains (String.Pattern "hello sync")
        String.length stderr `shouldEqual` 0
        result.status.success `shouldEqual` true
        result.status.code `shouldEqual` 0

      it "should compare async vs sync outputs" do
        let opts = CommandOptions.args ["-c", "echo hello compare"]
                <> CommandOptions.stdout CommandOptions.Piped
                <> CommandOptions.stderr CommandOptions.Piped
        
        -- Test async version
        cmdAsync <- liftEffect $ Command.new opts "sh"
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
        -- With clearEnv true, the environment variable should not be available
        stdout `shouldSatisfy` (\s -> s == "" || s == "\n")

      it "should handle command with environment variables" do
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
        
        -- Should be empty output
        String.length stdout `shouldEqual` 0
        String.length stderr `shouldEqual` 0
        -- But should have success status
        result.status.success `shouldEqual` true

      it "should handle command failure gracefully" do
        let opts = CommandOptions.args ["-c", "exit 42"]
                <> CommandOptions.stdout CommandOptions.Piped
                <> CommandOptions.stderr CommandOptions.Piped
        cmd <- liftEffect $ Command.new opts "sh"
        result <- Command.output cmd

        -- Should capture exit code
        result.status.code `shouldEqual` 42
        result.status.success `shouldEqual` false

      it "should handle stderr output" do
        let opts = CommandOptions.args ["-c", "echo error message >&2"]
                <> CommandOptions.stdout CommandOptions.Piped
                <> CommandOptions.stderr CommandOptions.Piped
        cmd <- liftEffect $ Command.new opts "sh"
        result <- Command.output cmd

        let stderr = decodeText result.stderr
        stderr `shouldSatisfy` String.contains (String.Pattern "error message")

    describe "ChildProcess management" do
      it "should spawn a child process and kill it" do
        let opts = CommandOptions.args ["-c", "sleep 10"]
        cmd <- liftEffect $ Command.new opts "sh"
        child <- liftEffect $ Command.spawn cmd
        
        -- Child should be running initially
        isAlive <- liftEffect $ ChildProcess.status child >>= case _ of
            ChildProcess.Running -> pure true
            _ -> pure false
        isAlive `shouldEqual` true
        
        -- Kill the process and verify it terminates
        _ <- liftEffect $ ChildProcess.kill SIGTERM child
        
        -- Allow a bit of time for the signal to be processed
        finalStatus <- ChildProcess.await child
        
        -- Should no longer be running
        finalStatus.success `shouldEqual` false

      it "should get process ID for child process" do
        let opts = CommandOptions.args ["-c", "sleep 5"]
        cmd <- liftEffect $ Command.new opts "sh"
        child <- liftEffect $ Command.spawn cmd
        
        -- Get PID and verify it's a positive number
        pid <- liftEffect $ ChildProcess.pid child
        pid `shouldSatisfy` (_ > 0)
        
        -- Clean up
        _ <- liftEffect $ ChildProcess.kill SIGKILL child
        _ <- ChildProcess.await child
        pure unit

      it "should communicate with child process through stdin" do
        let opts = CommandOptions.args []
                <> CommandOptions.stdout CommandOptions.Piped
                <> CommandOptions.stdin CommandOptions.Piped
        cmd <- liftEffect $ Command.new opts "cat"
        child <- liftEffect $ Command.spawn cmd
        
        -- Write to stdin
        stdin <- liftEffect $ ChildProcess.stdin child
        _ <- liftEffect $ ChildProcess.writeAll (encodeText "hello from stdin") stdin
        liftEffect $ ChildProcess.closeStdin child
        
        -- Read from stdout
        stdout <- ChildProcess.output child
        let output = decodeText stdout.stdout
        
        -- Check that what we wrote to stdin came back on stdout
        output `shouldEqual` "hello from stdin"