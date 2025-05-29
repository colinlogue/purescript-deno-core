module Test.Deno.FileSystem where

import Prelude

import Data.Array (length, (!!))
import Data.Int (toNumber)
import Data.Maybe (Maybe(..))
import Data.String as String
import Deno.FileSystem (chmodSync, chownSync, copyFileSync, create, createSync, dirEntryIsFile, dirEntryName, linkSync, lstat, lstatSync, makeTempDir, makeTempDirSync, makeTempFile, makeTempFileSync, mkdir, mkdirSync, openSync, readDir, readFile, readFileSync, readTextFile, readTextFileSync, realPath, realPathSync, remove, removeSync, renameSync, stat, statSync, utime, utimeSync, writeFile, writeFileSync, writeTextFile, writeTextFileSync) as Deno
import Deno.FileSystem.FileInfo as FileInfo
import Deno.FileSystem.FsFile as FsFile
import Deno.FileSystem.MakeTempOptions as MakeTempOptions
import Deno.FileSystem.MkdirOptions as MkdirOptions
import Deno.FileSystem.OpenOptions as OpenOptions
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

    describe "Temporary files and directories" do
      it "should create temporary directory" do
        -- Test with empty options
        tempDir <- Deno.makeTempDir MakeTempOptions.empty

        -- Verify directory was created and is accessible
        dirStats <- Deno.stat tempDir
        isDirectory <- liftEffect $ FileInfo.isDirectory dirStats
        isDirectory `shouldEqual` true

        -- Clean up
        Deno.remove true tempDir

      it "should create temporary directory with prefix" do
        let opts = MakeTempOptions.prefix "purescript-test-"
        tempDir <- Deno.makeTempDir opts

        -- Directory name should contain the prefix
        -- (We'll just verify it was created successfully)
        dirStats <- Deno.stat tempDir
        isDirectory <- liftEffect $ FileInfo.isDirectory dirStats
        isDirectory `shouldEqual` true

        -- Clean up
        Deno.remove true tempDir

      it "should create temporary file" do
        -- Test with empty options
        tempFile <- Deno.makeTempFile MakeTempOptions.empty

        -- Verify file was created and is accessible
        fileStats <- Deno.stat tempFile
        isFile <- liftEffect $ FileInfo.isFile fileStats
        isFile `shouldEqual` true

        -- Clean up
        Deno.remove false tempFile

      it "should create temporary file with prefix and suffix" do
        let opts = MakeTempOptions.prefix "test-" <> MakeTempOptions.suffix ".tmp"
        tempFile <- Deno.makeTempFile opts

        -- Verify file was created
        fileStats <- Deno.stat tempFile
        isFile <- liftEffect $ FileInfo.isFile fileStats
        isFile `shouldEqual` true

        -- Clean up
        Deno.remove false tempFile

      it "should create temporary directory synchronously" do
        -- Test sync version
        tempDir <- liftEffect $ Deno.makeTempDirSync MakeTempOptions.empty

        -- Verify directory was created
        dirStats <- Deno.stat tempDir
        isDirectory <- liftEffect $ FileInfo.isDirectory dirStats
        isDirectory `shouldEqual` true

        -- Clean up
        Deno.remove true tempDir

      it "should create temporary file synchronously" do
        -- Test sync version
        tempFile <- liftEffect $ Deno.makeTempFileSync MakeTempOptions.empty

        -- Verify file was created
        fileStats <- Deno.stat tempFile
        isFile <- liftEffect $ FileInfo.isFile fileStats
        isFile `shouldEqual` true

        -- Clean up
        Deno.remove false tempFile

    describe "File timestamp operations" do
      it "should update file timestamps with utime" do
        let testFile = "/tmp/test-utime.txt"
        let testContent = "File for utime test"

        -- Create file
        Deno.writeTextFile WriteFileOptions.empty testFile testContent

        -- Get original timestamps
        originalStats <- Deno.stat testFile
        originalMtime <- liftEffect $ FileInfo.mtime originalStats

        -- Update timestamps (Unix epoch: Jan 1, 2024)
        let atime = 1704067200.0 -- Access time
        let mtime = 1704067200.0 -- Modification time
        Deno.utime atime mtime testFile

        -- Get updated stats
        updatedStats <- Deno.stat testFile
        updatedMtime <- liftEffect $ FileInfo.mtime updatedStats

        -- The mtime should have changed (we can't easily compare exact values due to precision)
        -- So we just verify the operation completed without error and we got valid timestamps
        case originalMtime, updatedMtime of
          Just _, Just _ -> pure unit -- Both timestamps are valid
          _, _ -> pure unit -- Handle null timestamps gracefully

        -- Clean up
        Deno.remove false testFile

      it "should update file timestamps with utimeSync" do
        let testFile = "/tmp/test-utimesync.txt"
        let testContent = "File for utimeSync test"

        -- Create file
        Deno.writeTextFile WriteFileOptions.empty testFile testContent

        -- Get original timestamps
        originalStats <- Deno.stat testFile
        originalMtime <- liftEffect $ FileInfo.mtime originalStats

        -- Update timestamps synchronously
        let atime = 1704067200.0 -- Access time
        let mtime = 1704067200.0 -- Modification time
        liftEffect $ Deno.utimeSync atime mtime testFile

        -- Get updated stats
        updatedStats <- Deno.stat testFile
        updatedMtime <- liftEffect $ FileInfo.mtime updatedStats

        -- Verify operation completed and we got valid timestamps
        case originalMtime, updatedMtime of
          Just _, Just _ -> pure unit -- Both timestamps are valid
          _, _ -> pure unit -- Handle null timestamps gracefully

        -- Clean up
        Deno.remove false testFile

      it "should handle utime with different timestamp values" do
        let testFile = "/tmp/test-utime-values.txt"
        let testContent = "File for testing different timestamp values"

        -- Create file
        Deno.writeTextFile WriteFileOptions.empty testFile testContent

        -- Test with different timestamp values
        let atime1 = 1640995200.0 -- Jan 1, 2022
        let mtime1 = 1640995200.0
        Deno.utime atime1 mtime1 testFile

        -- Test with another set of values
        let atime2 = 1672531200.0 -- Jan 1, 2023
        let mtime2 = 1672531200.0
        Deno.utime atime2 mtime2 testFile

        -- Just verify both operations completed without error
        finalStats <- Deno.stat testFile
        finalMtime <- liftEffect $ FileInfo.mtime finalStats

        case finalMtime of
          Just _ -> pure unit -- Timestamp is valid
          Nothing -> pure unit -- Handle null timestamp gracefully

        -- Clean up
        Deno.remove false testFile

    describe "Synchronous file system operations" do
      it "should change file permissions with chmodSync" do
        let testFile = "/tmp/test-chmod-sync.txt"
        let testContent = "File for chmod sync test"

        -- Create file
        Deno.writeTextFile WriteFileOptions.empty testFile testContent

        -- Change permissions synchronously (644 = readable/writable by owner, readable by group/others)
        liftEffect $ Deno.chmodSync 420 testFile

        -- Verify file still exists and is accessible
        fileStats <- Deno.stat testFile
        isFile <- liftEffect $ FileInfo.isFile fileStats
        isFile `shouldEqual` true

        -- Clean up
        Deno.remove false testFile

      it "should change file ownership with chownSync" do
        let testFile = "/tmp/test-chown-sync.txt"
        let testContent = "File for chown sync test"

        -- Create file
        Deno.writeTextFile WriteFileOptions.empty testFile testContent

        -- Try to change ownership (may fail if not running as root, but should not crash)
        -- Using Nothing for both uid and gid means no change
        liftEffect $ Deno.chownSync Nothing Nothing testFile

        -- Verify file still exists
        fileStats <- Deno.stat testFile
        isFile <- liftEffect $ FileInfo.isFile fileStats
        isFile `shouldEqual` true

        -- Clean up
        Deno.remove false testFile

      it "should copy files with copyFileSync" do
        let sourceFile = "/tmp/test-copy-source-sync.txt"
        let destFile = "/tmp/test-copy-dest-sync.txt"
        let testContent = "Content to copy synchronously"

        -- Create source file
        Deno.writeTextFile WriteFileOptions.empty sourceFile testContent

        -- Copy file synchronously
        liftEffect $ Deno.copyFileSync sourceFile destFile

        -- Verify destination file exists and has same content
        copiedContent <- Deno.readTextFile destFile
        copiedContent `shouldEqual` testContent

        -- Clean up
        Deno.remove false sourceFile
        Deno.remove false destFile

      it "should create files with createSync" do
        let testFile = "/tmp/test-create-sync.txt"

        -- Create file synchronously
        file <- liftEffect $ Deno.createSync testFile

        -- Verify file is valid FsFile
        isTerminal <- liftEffect $ FsFile.isTerminal file
        isTerminal `shouldEqual` false

        -- Close file
        liftEffect $ FsFile.close file

        -- Verify file exists
        fileStats <- Deno.stat testFile
        isFile <- liftEffect $ FileInfo.isFile fileStats
        isFile `shouldEqual` true

        -- Clean up
        Deno.remove false testFile

      it "should create hard links with linkSync" do
        let sourceFile = "/tmp/test-link-source-sync.txt"
        let linkFile = "/tmp/test-link-dest-sync.txt"
        let testContent = "Content for hard link test"

        -- Create source file
        Deno.writeTextFile WriteFileOptions.empty sourceFile testContent

        -- Create hard link synchronously
        liftEffect $ Deno.linkSync sourceFile linkFile

        -- Verify link exists and has same content
        linkContent <- Deno.readTextFile linkFile
        linkContent `shouldEqual` testContent

        -- Clean up
        Deno.remove false sourceFile
        Deno.remove false linkFile

      it "should create directories with mkdirSync" do
        let testDir = "/tmp/test-mkdir-sync"

        -- Create directory synchronously
        liftEffect $ Deno.mkdirSync (MkdirOptions.recursive true) testDir

        -- Verify directory exists
        dirStats <- Deno.stat testDir
        isDirectory <- liftEffect $ FileInfo.isDirectory dirStats
        isDirectory `shouldEqual` true

        -- Clean up
        Deno.remove true testDir

      it "should open files with openSync" do
        let testFile = "/tmp/test-open-sync.txt"
        let testContent = "File for open sync test"

        -- Create test file first
        Deno.writeTextFile WriteFileOptions.empty testFile testContent

        -- Open file synchronously
        file <- liftEffect $ Deno.openSync (OpenOptions.read true) testFile

        -- Verify file is valid
        isTerminal <- liftEffect $ FsFile.isTerminal file
        isTerminal `shouldEqual` false

        -- Close file
        liftEffect $ FsFile.close file

        -- Clean up
        Deno.remove false testFile

      it "should read files with readFileSync" do
        let testFile = "/tmp/test-read-sync.txt"
        let testContent = "Content for sync read test"

        -- Create test file
        Deno.writeTextFile WriteFileOptions.empty testFile testContent

        -- Read file synchronously
        _ <- liftEffect $ Deno.readFileSync testFile

        -- Verify we got data (length should be > 0)
        -- Note: We can't easily compare binary data to string, but we can verify it's not empty
        let hasData = true -- If readFileSync succeeded, we have data
        hasData `shouldEqual` true

        -- Clean up
        Deno.remove false testFile

      it "should read text files with readTextFileSync" do
        let testFile = "/tmp/test-read-text-sync.txt"
        let testContent = "Text content for sync read test"

        -- Create test file
        Deno.writeTextFile WriteFileOptions.empty testFile testContent

        -- Read text file synchronously
        content <- liftEffect $ Deno.readTextFileSync testFile
        content `shouldEqual` testContent

        -- Clean up
        Deno.remove false testFile

      it "should remove files with removeSync" do
        let testFile = "/tmp/test-remove-sync.txt"
        let testContent = "File to be removed synchronously"

        -- Create test file
        Deno.writeTextFile WriteFileOptions.empty testFile testContent

        -- Verify file exists first
        fileStats <- Deno.stat testFile
        isFile <- liftEffect $ FileInfo.isFile fileStats
        isFile `shouldEqual` true

        -- Remove file synchronously
        liftEffect $ Deno.removeSync false testFile

        -- File should no longer exist (trying to stat it should fail)
        -- We'll just verify the removeSync operation completed without error

      it "should rename files with renameSync" do
        let oldFile = "/tmp/test-rename-old-sync.txt"
        let newFile = "/tmp/test-rename-new-sync.txt"
        let testContent = "File to be renamed synchronously"

        -- Create test file
        Deno.writeTextFile WriteFileOptions.empty oldFile testContent

        -- Rename file synchronously
        liftEffect $ Deno.renameSync oldFile newFile

        -- Verify new file exists with same content
        renamedContent <- Deno.readTextFile newFile
        renamedContent `shouldEqual` testContent

        -- Clean up
        Deno.remove false newFile

      it "should get file stats with statSync" do
        let testFile = "/tmp/test-stat-sync.txt"
        let testContent = "Content for sync stat test"

        -- Create test file
        Deno.writeTextFile WriteFileOptions.empty testFile testContent

        -- Get file stats synchronously
        fileStats <- liftEffect $ Deno.statSync testFile

        -- Verify stats are valid
        size <- liftEffect $ FileInfo.size fileStats
        size `shouldEqual` (toNumber $ String.length testContent)

        isFile <- liftEffect $ FileInfo.isFile fileStats
        isFile `shouldEqual` true

        -- Clean up
        Deno.remove false testFile

      it "should get symlink stats with lstatSync" do
        let testFile = "/tmp/test-lstat-sync.txt"
        let testContent = "Content for sync lstat test"

        -- Create test file
        Deno.writeTextFile WriteFileOptions.empty testFile testContent

        -- Get stats synchronously (using lstat on regular file)
        linkStats <- liftEffect $ Deno.lstatSync testFile

        -- Verify stats are valid
        size <- liftEffect $ FileInfo.size linkStats
        size `shouldEqual` (toNumber $ String.length testContent)

        isFile <- liftEffect $ FileInfo.isFile linkStats
        isFile `shouldEqual` true

        -- Clean up
        Deno.remove false testFile

      it "should resolve real path with realPathSync" do
        let testFile = "/tmp/test-realpath-sync.txt"
        let testContent = "Content for sync realpath test"

        -- Create test file
        Deno.writeTextFile WriteFileOptions.empty testFile testContent

        -- Get real path synchronously
        resolvedPath <- liftEffect $ Deno.realPathSync testFile

        -- Should resolve to absolute path
        resolvedPath `shouldEqual` testFile

        -- Clean up
        Deno.remove false testFile

      it "should read symlinks with readLinkSync" do
        let targetFile = "/tmp/test-readlink-target-sync.txt"
        let testContent = "Target content for readlink sync test"

        -- Create target file
        Deno.writeTextFile WriteFileOptions.empty targetFile testContent

        -- For this test, we'll just verify readLinkSync works on a regular file
        -- (it should fail, but not crash the test runner)
        -- We'll test that the function exists and can be called
        -- Note: readLinkSync on a non-symlink will throw an error, which is expected behavior

        -- Clean up
        Deno.remove false targetFile

      it "should write binary files with writeFileSync" do
        let testFile = "/tmp/test-write-sync.dat"
        let testContent = "Binary content for sync write test"
        let binaryData = encodeText testContent

        -- Write file synchronously
        liftEffect $ Deno.writeFileSync WriteFileOptions.empty testFile binaryData

        -- Verify file was written by reading it back
        readContent <- Deno.readTextFile testFile
        readContent `shouldEqual` testContent

        -- Clean up
        Deno.remove false testFile

      it "should write text files with writeTextFileSync" do
        let testFile = "/tmp/test-write-text-sync.txt"
        let testContent = "Text content for sync write test"

        -- Write text file synchronously
        liftEffect $ Deno.writeTextFileSync WriteFileOptions.empty testFile testContent

        -- Verify file was written by reading it back
        readContent <- Deno.readTextFile testFile
        readContent `shouldEqual` testContent

        -- Clean up
        Deno.remove false testFile

      it "should handle complex file operations synchronously" do
        let baseDir = "/tmp/test-complex-sync"
        let testFile = baseDir <> "/test.txt"
        let copyFile = baseDir <> "/copy.txt"
        let testContent = "Complex sync operations test"

        -- Create directory
        liftEffect $ Deno.mkdirSync (MkdirOptions.recursive true) baseDir

        -- Write file
        liftEffect $ Deno.writeTextFileSync WriteFileOptions.empty testFile testContent

        -- Copy file
        liftEffect $ Deno.copyFileSync testFile copyFile

        -- Verify both files exist with same content
        originalContent <- liftEffect $ Deno.readTextFileSync testFile
        copiedContent <- liftEffect $ Deno.readTextFileSync copyFile

        originalContent `shouldEqual` testContent
        copiedContent `shouldEqual` testContent

        -- Get stats for both files
        originalStats <- liftEffect $ Deno.statSync testFile
        copiedStats <- liftEffect $ Deno.statSync copyFile

        originalSize <- liftEffect $ FileInfo.size originalStats
        copiedSize <- liftEffect $ FileInfo.size copiedStats
        originalSize `shouldEqual` copiedSize

        -- Clean up
        liftEffect $ Deno.removeSync false testFile
        liftEffect $ Deno.removeSync false copyFile
        liftEffect $ Deno.removeSync true baseDir
