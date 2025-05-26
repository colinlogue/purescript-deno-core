module Test.Deno.FileSystem where

import Prelude

import Data.Array (length, (!!))
import Data.Int (toNumber)
import Data.Maybe (Maybe(..))
import Data.String as String
import Deno.FileSystem (create, dirEntryIsFile, dirEntryName, lstat, mkdir, readDir, readFile, readTextFile, realPath, remove, stat, writeFile, writeTextFile) as Deno
import Deno.FileSystem.FileInfo as FileInfo
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

    describe "New file system operations" do
      it "should read directory entries with readDir" do
        let testDir = "/tmp/test-readdir"
        let testFile = testDir <> "/test-file.txt"

        -- Create test directory and file
        Deno.mkdir (MkdirOptions.recursive true) testDir
        Deno.writeTextFile WriteFileOptions.empty testFile "test content"

        -- Read directory entries
        entries <- Deno.readDir testDir

        -- Should have at least one entry (our test file)
        let entryCount = length entries
        entryCount `shouldEqual` 1

        -- Check first entry properties
        case entries !! 0 of
          Just entry -> do
            name <- liftEffect $ Deno.dirEntryName entry
            isFile <- liftEffect $ Deno.dirEntryIsFile entry
            name `shouldEqual` "test-file.txt"
            isFile `shouldEqual` true
          Nothing -> pure unit -- This shouldn't happen

        -- Clean up
        Deno.remove false testFile
        Deno.remove true testDir

      it "should get file stats with stat" do
        let testFile = "/tmp/test-stat.txt"
        let testContent = "test content for stat"

        -- Create test file
        Deno.writeTextFile WriteFileOptions.empty testFile testContent

        -- Get file stats
        fileStats <- Deno.stat testFile

        -- Basic validation that we got stats (size should be > 0)
        size <- liftEffect $ FileInfo.size fileStats
        size `shouldEqual` (toNumber $ String.length testContent)

        -- Clean up
        Deno.remove false testFile

      it "should get symlink stats with lstat" do
        let testFile = "/tmp/test-lstat-target.txt"

        -- Create test file
        Deno.writeTextFile WriteFileOptions.empty testFile "target content"

        -- We'll test lstat on the original file for now
        linkStats <- Deno.lstat testFile

        -- Should get valid stats
        size <- liftEffect $ FileInfo.size linkStats
        size `shouldEqual` 14.0 -- length of "target content"

        -- Clean up
        Deno.remove false testFile

      it "should resolve real path with realPath" do
        let testFile = "/tmp/test-realpath.txt"

        -- Create test file
        Deno.writeTextFile WriteFileOptions.empty testFile "real path test"

        -- Get real path
        resolvedPath <- Deno.realPath testFile

        -- Should resolve to absolute path
        resolvedPath `shouldEqual` testFile

        -- Clean up
        Deno.remove false testFile
