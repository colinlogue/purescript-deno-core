module Test.Deno.FileSystem where

import Prelude

import Data.ArrayBuffer.Typed as Typed
import Deno.FileSystem (create, mkdir, readFile, readTextFile, remove, writeFile, writeTextFile) as Deno
import Deno.FileSystem.FsFile as FsFile
import Deno.FileSystem.MkdirOptions as MkdirOptions
import Deno.FileSystem.WriteFileOptions as WriteFileOptions
import Effect.Class (liftEffect)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)
import Test.Web.Streams.WritableStream (encodeText)
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

      it "should write and read binary files" do
        let testContent = "Hello from binary file operations!"
        let testFile = "/tmp/test-binary-file.dat"

        -- Encode text to Uint8Array
        let binaryData = encodeText testContent

        -- Write binary file
        Deno.writeFile WriteFileOptions.empty testFile binaryData

        -- Read binary file back
        _ <- Deno.readFile testFile

        -- Clean up (test passes if no exception thrown)
        Deno.remove false testFile

    describe "Directory operations" do
      it "should handle directory creation and removal" do
        let testDir = "/tmp/test-purescript-dir"

        -- Create directory
        Deno.mkdir (MkdirOptions.recursive true) testDir

        -- Clean up
        Deno.remove true testDir
