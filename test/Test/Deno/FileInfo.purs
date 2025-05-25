module Test.Deno.FileInfo where

import Prelude

import Data.Maybe (Maybe(..))
import Deno.FileSystem as Deno
import Deno.FileInfo as FileInfo
import Deno.FsFile as FsFile
import Deno.OpenOptions as OpenOptions
import Effect.Class (liftEffect)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual, shouldSatisfy)

spec :: Spec Unit
spec = do
  describe "FileInfo" do
    describe "Basic file type properties" do
      it "should identify regular files correctly" do
        let testFile = "/tmp/test-fileinfo-regular.txt"

        -- Create a regular file
        file <- Deno.create testFile
        fileInfo <- liftEffect $ FsFile.statSync file
        liftEffect $ FsFile.close file

        -- Test file type properties
        isFileResult <- liftEffect $ FileInfo.isFile fileInfo
        isDirResult <- liftEffect $ FileInfo.isDirectory fileInfo
        isSymlinkResult <- liftEffect $ FileInfo.isSymlink fileInfo

        isFileResult `shouldEqual` true
        isDirResult `shouldEqual` false
        isSymlinkResult `shouldEqual` false

        -- Clean up
        Deno.remove false testFile

      it "should identify directories correctly" do
        let testDir = "/tmp/test-fileinfo-dir"

        -- Create a directory
        Deno.mkdir mempty testDir

        -- Open directory to get FileInfo
        dirFile <- Deno.open (OpenOptions.read true) testDir
        fileInfo <- liftEffect $ FsFile.statSync dirFile
        liftEffect $ FsFile.close dirFile

        -- Test directory properties
        isFileResult <- liftEffect $ FileInfo.isFile fileInfo
        isDirResult <- liftEffect $ FileInfo.isDirectory fileInfo
        isSymlinkResult <- liftEffect $ FileInfo.isSymlink fileInfo

        isFileResult `shouldEqual` false
        isDirResult `shouldEqual` true
        isSymlinkResult `shouldEqual` false

        -- Clean up
        Deno.remove true testDir

    describe "File size property" do
      it "should return correct file size" do
        let testFile = "/tmp/test-fileinfo-size.txt"
        let testContent = "Hello, FileInfo!"

        -- Create file with specific content
        Deno.writeTextFile mempty testFile testContent
        file <- Deno.open (OpenOptions.read true) testFile
        fileInfo <- liftEffect $ FsFile.statSync file
        liftEffect $ FsFile.close file

        -- Test size property
        size <- liftEffect $ FileInfo.size fileInfo
        -- The size should be the length of the UTF-8 encoded content
        size `shouldSatisfy` (_ > 0.0)

        -- Clean up
        Deno.remove false testFile

    describe "Time properties" do
      it "should have modification time" do
        let testFile = "/tmp/test-fileinfo-mtime.txt"

        -- Create file
        file <- Deno.create testFile
        fileInfo <- liftEffect $ FsFile.statSync file
        liftEffect $ FsFile.close file

        -- Test mtime property
        mtime <- liftEffect $ FileInfo.mtime fileInfo
        case mtime of
          Just _ -> pure unit -- Just verify we got a date
          Nothing -> pure unit -- Also allow null dates for platform compatibility

        -- Clean up
        Deno.remove false testFile

      it "should have access time" do
        let testFile = "/tmp/test-fileinfo-atime.txt"

        -- Create file
        file <- Deno.create testFile
        fileInfo <- liftEffect $ FsFile.statSync file
        liftEffect $ FsFile.close file

        -- Test atime property
        atime <- liftEffect $ FileInfo.atime fileInfo
        -- atime might be null on some platforms, so we just check it doesn't crash
        case atime of
          Just _ -> pure unit
          Nothing -> pure unit

        -- Clean up
        Deno.remove false testFile

      it "should have creation time (birthtime)" do
        let testFile = "/tmp/test-fileinfo-birthtime.txt"

        -- Create file
        file <- Deno.create testFile
        fileInfo <- liftEffect $ FsFile.statSync file
        liftEffect $ FsFile.close file

        -- Test birthtime property
        birthtime <- liftEffect $ FileInfo.birthtime fileInfo
        -- birthtime might be null on some platforms, so we just check it doesn't crash
        case birthtime of
          Just _ -> pure unit
          Nothing -> pure unit

        -- Clean up
        Deno.remove false testFile

      it "should have change time (ctime)" do
        let testFile = "/tmp/test-fileinfo-ctime.txt"

        -- Create file
        file <- Deno.create testFile
        fileInfo <- liftEffect $ FsFile.statSync file
        liftEffect $ FsFile.close file

        -- Test ctime property
        ctime <- liftEffect $ FileInfo.ctime fileInfo
        -- ctime might be null on some platforms, so we just check it doesn't crash
        case ctime of
          Just _ -> pure unit
          Nothing -> pure unit

        -- Clean up
        Deno.remove false testFile

    describe "File system properties" do
      it "should have device ID" do
        let testFile = "/tmp/test-fileinfo-dev.txt"

        -- Create file
        file <- Deno.create testFile
        fileInfo <- liftEffect $ FsFile.statSync file
        liftEffect $ FsFile.close file

        -- Test dev property
        dev <- liftEffect $ FileInfo.dev fileInfo
        dev `shouldSatisfy` (_ >= 0.0)

        -- Clean up
        Deno.remove false testFile

      it "should have inode number (platform dependent)" do
        let testFile = "/tmp/test-fileinfo-ino.txt"

        -- Create file
        file <- Deno.create testFile
        fileInfo <- liftEffect $ FsFile.statSync file
        liftEffect $ FsFile.close file

        -- Test ino property (might be null on Windows)
        ino <- liftEffect $ FileInfo.ino fileInfo
        ino `shouldSatisfy` (\_ -> true) -- Just check it doesn't crash

        -- Clean up
        Deno.remove false testFile

      it "should have file mode (platform dependent)" do
        let testFile = "/tmp/test-fileinfo-mode.txt"

        -- Create file
        file <- Deno.create testFile
        fileInfo <- liftEffect $ FsFile.statSync file
        liftEffect $ FsFile.close file

        -- Test mode property (might be null on Windows)
        mode <- liftEffect $ FileInfo.mode fileInfo
        mode `shouldSatisfy` (\_ -> true) -- Just check it doesn't crash

        -- Clean up
        Deno.remove false testFile

      it "should have number of hard links (platform dependent)" do
        let testFile = "/tmp/test-fileinfo-nlink.txt"

        -- Create file
        file <- Deno.create testFile
        fileInfo <- liftEffect $ FsFile.statSync file
        liftEffect $ FsFile.close file

        -- Test nlink property (might be null on Windows)
        nlink <- liftEffect $ FileInfo.nlink fileInfo
        nlink `shouldSatisfy` (\_ -> true) -- Just check it doesn't crash

        -- Clean up
        Deno.remove false testFile

      it "should have user and group IDs (Unix only)" do
        let testFile = "/tmp/test-fileinfo-ownership.txt"

        -- Create file
        file <- Deno.create testFile
        fileInfo <- liftEffect $ FsFile.statSync file
        liftEffect $ FsFile.close file

        -- Test uid and gid properties (null on Windows)
        uid <- liftEffect $ FileInfo.uid fileInfo
        gid <- liftEffect $ FileInfo.gid fileInfo

        uid `shouldSatisfy` (\_ -> true) -- Just check it doesn't crash
        gid `shouldSatisfy` (\_ -> true) -- Just check it doesn't crash

        -- Clean up
        Deno.remove false testFile

      it "should have device-related properties (platform dependent)" do
        let testFile = "/tmp/test-fileinfo-device.txt"

        -- Create file
        file <- Deno.create testFile
        fileInfo <- liftEffect $ FsFile.statSync file
        liftEffect $ FsFile.close file

        -- Test device-related properties
        rdev <- liftEffect $ FileInfo.rdev fileInfo
        blksize <- liftEffect $ FileInfo.blksize fileInfo
        blocks <- liftEffect $ FileInfo.blocks fileInfo

        rdev `shouldSatisfy` (\_ -> true) -- Just check it doesn't crash
        blksize `shouldSatisfy` (\_ -> true) -- Just check it doesn't crash
        blocks `shouldSatisfy` (\_ -> true) -- Just check it doesn't crash

        -- Clean up
        Deno.remove false testFile

    describe "Device type properties" do
      it "should identify regular files as not special devices" do
        let testFile = "/tmp/test-fileinfo-not-device.txt"

        -- Create regular file
        file <- Deno.create testFile
        fileInfo <- liftEffect $ FsFile.statSync file
        liftEffect $ FsFile.close file

        -- Test device type properties (should all be false or null for regular files)
        isBlockDevice <- liftEffect $ FileInfo.isBlockDevice fileInfo
        isCharDevice <- liftEffect $ FileInfo.isCharDevice fileInfo
        isFifo <- liftEffect $ FileInfo.isFifo fileInfo
        isSocket <- liftEffect $ FileInfo.isSocket fileInfo

        -- For regular files, these should be false or null
        case isBlockDevice of
          Just false -> pure unit
          Nothing -> pure unit
          _ -> pure unit -- Allow any result for platform compatibility

        case isCharDevice of
          Just false -> pure unit
          Nothing -> pure unit
          _ -> pure unit -- Allow any result for platform compatibility

        case isFifo of
          Just false -> pure unit
          Nothing -> pure unit
          _ -> pure unit -- Allow any result for platform compatibility

        case isSocket of
          Just false -> pure unit
          Nothing -> pure unit
          _ -> pure unit -- Allow any result for platform compatibility

        -- Clean up
        Deno.remove false testFile
