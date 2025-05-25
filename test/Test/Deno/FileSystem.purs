module Test.Deno.FileSystem where

import Prelude

import Deno.FileSystem (create, mkdir, readTextFile, remove, writeTextFile) as Deno
import Deno.FsFile as FsFile
import Deno.MkdirOptions as MkdirOptions
import Deno.WriteFileOptions as WriteFileOptions
import Effect.Class (liftEffect)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)
import Web.Streams.WritableStream as WritableStream

spec :: Spec Unit
spec = do
  describe "Deno FileSystem" do
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

    describe "Directory operations" do
      it "should handle directory creation and removal" do
        let testDir = "/tmp/test-purescript-dir"

        -- Create directory
        Deno.mkdir (MkdirOptions.recursive true) testDir

        -- Clean up
        Deno.remove true testDir
