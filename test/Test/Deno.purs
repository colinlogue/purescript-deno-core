module Test.Deno where

import Prelude

import Deno (create, mkdir, readTextFile, remove, writeTextFile) as Deno
import Deno.FsFile as FsFile
import Deno.MkdirOptions as MkdirOptions
import Deno.Runtime (chdir, cwd) as Deno
import Deno.WriteFileOptions as WriteFileOptions
import Effect (Effect)
import Effect.Class (liftEffect)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual, shouldNotEqual)
import Web.Streams.WritableStream as WritableStream

foreign import stdoutIsTerminal :: Effect Boolean

spec :: Spec Unit
spec = do
  describe "Deno Core" do
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
