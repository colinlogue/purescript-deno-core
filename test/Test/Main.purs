module Test.Main where

import Prelude

import Data.String as String
import Deno as Deno
import Deno.FsFile as FsFile
import Deno.MkdirOptions as MkdirOptions
import Deno.WriteFileOptions as WriteFileOptions
import Effect (Effect)
import Effect.Class (liftEffect)
import Test.Spec (describe, it)
import Test.Spec.Assertions (shouldSatisfy, shouldEqual, shouldNotEqual)
import Test.Spec.Reporter (consoleReporter)
import Test.Spec.Runner.Deno (runSpecAndExitProcess)
import Web.Streams.WritableStream as WritableStream

foreign import stdoutIsTerminal :: Effect Boolean

main :: Effect Unit
main = runSpecAndExitProcess [ consoleReporter ] spec
  where
    spec = do
      describe "Deno Core" do
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

        describe "File operations" do
          it "should write and read text files" do
            let testContent = "Hello from PureScript Deno bindings!"
            let testFile = "/tmp/test-purescript-deno.txt"

            -- Write file
            Deno.writeTextFile WriteFileOptions.empty testFile testContent

            -- Read file back
            content <- Deno.readTextFile testFile
            content `shouldEqual` testContent

            -- Clean up
            Deno.remove false testFile

          it "should create and use FsFile for streaming properties" do
            let testFile = "/tmp/test-stream.txt"

            -- Create file
            file <- Deno.create testFile

            -- Test FsFile properties
            isTerminal <- liftEffect $ FsFile.isTerminal file
            isTerminal `shouldEqual` false

            -- Get writable stream and test basic properties
            writableStream <- liftEffect $ FsFile.writable file
            locked <- liftEffect $ WritableStream.locked writableStream
            locked `shouldEqual` false

            -- Get readable stream
            _ <- liftEffect $ FsFile.readable file
            -- Just verify we can get the readable stream without error

            -- Close the file
            liftEffect $ FsFile.close file

            -- Clean up
            Deno.remove false testFile

        describe "File system utilities" do
          it "should handle directory operations" do
            let testDir = "/tmp/test-purescript-dir"

            -- Create directory
            Deno.mkdir (MkdirOptions.recursive true) testDir

            -- Test that we can change to it and back
            originalCwd <- liftEffect Deno.cwd
            liftEffect $ Deno.chdir testDir
            newCwd <- liftEffect Deno.cwd
            newCwd `shouldNotEqual` originalCwd

            -- Change back
            liftEffect $ Deno.chdir originalCwd

            -- Clean up
            Deno.remove true testDir
