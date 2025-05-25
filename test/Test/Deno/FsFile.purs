module Test.Deno.FsFile where

import Prelude

import Data.ArrayBuffer.Typed as Typed
import Data.Maybe (Maybe(..), fromMaybe)
import Deno as Deno
import Deno.FsFile as FsFile
import Deno.OpenOptions as OpenOptions
import Effect.Class (liftEffect)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual, shouldSatisfy)

spec :: Spec Unit
spec = do
  describe "FsFile" do
    describe "Locking operations" do
      it "should lock and unlock file synchronously" do
        let testFile = "/tmp/test-fsfile-locksync.txt"

        -- Create file
        file <- Deno.create testFile

        -- Test lockSync with exclusive lock
        liftEffect $ FsFile.lockSync true file

        -- Verify file is still accessible (basic test)
        isTerminal <- liftEffect $ FsFile.isTerminal file
        isTerminal `shouldEqual` false

        -- Unlock the file using unlockSync
        liftEffect $ FsFile.unlockSync file

        -- Close the file
        liftEffect $ FsFile.close file

        -- Clean up
        Deno.remove false testFile

      it "should lock and unlock file using both sync and async methods" do
        let testFile = "/tmp/test-fsfile-mixed-lock.txt"

        -- Create file
        file <- Deno.create testFile

        -- Test lockSync with exclusive lock
        liftEffect $ FsFile.lockSync true file

        -- Unlock using async unlock
        FsFile.unlock file

        -- Lock again with async lock
        FsFile.lock true file

        -- Unlock using unlockSync
        liftEffect $ FsFile.unlockSync file

        -- Close the file
        liftEffect $ FsFile.close file

        -- Clean up
        Deno.remove false testFile

      it "should lock and unlock file asynchronously" do
        let testFile = "/tmp/test-fsfile-lock.txt"

        -- Create file
        file <- Deno.create testFile

        -- Test async lock with exclusive lock
        FsFile.lock true file

        -- Verify file is still accessible (basic test)
        isTerminal <- liftEffect $ FsFile.isTerminal file
        isTerminal `shouldEqual` false

        -- Unlock the file
        FsFile.unlock file

        -- Close the file
        liftEffect $ FsFile.close file

        -- Clean up
        Deno.remove false testFile

    describe "File properties" do
      it "should check if file is terminal" do
        let testFile = "/tmp/test-fsfile-terminal.txt"

        -- Create file
        file <- Deno.create testFile

        -- Test isTerminal (should be false for regular files)
        isTerminal <- liftEffect $ FsFile.isTerminal file
        isTerminal `shouldEqual` false

        -- Close the file
        liftEffect $ FsFile.close file

        -- Clean up
        Deno.remove false testFile

    describe "Stream properties" do
      it "should get readable and writable streams" do
        let testFile = "/tmp/test-fsfile-streams.txt"

        -- Create file
        file <- Deno.create testFile

        -- Get streams (just verify we can get them without error)
        _ <- liftEffect $ FsFile.readable file
        _ <- liftEffect $ FsFile.writable file

        -- Close the file
        liftEffect $ FsFile.close file

        -- Clean up
        Deno.remove false testFile

    describe "Read operations" do
      it "should read data from file into Uint8Array buffer" do
        let testFile = "/tmp/test-fsfile-read.txt"
        let testContent = "Hello from read test!"

        -- Create and write to file first
        Deno.writeTextFile mempty testFile testContent

        -- Open file for reading
        file <- Deno.open (OpenOptions.read true) testFile

        -- Create a buffer to read into (enough space for our content)
        buffer <- liftEffect $ Typed.empty 30 -- Create 30-byte buffer

        -- Read from file
        bytesRead <- FsFile.read buffer file

        -- Should have read some bytes
        let actualBytesRead = fromMaybe 0 bytesRead
        actualBytesRead `shouldSatisfy` (_ > 0)

        -- Close file
        liftEffect $ FsFile.close file

        -- Clean up
        Deno.remove false testFile

      it "should read partial data when buffer is smaller than file" do
        let testFile = "/tmp/test-fsfile-read-partial.txt"
        let testContent = "This is a longer test content for partial reading"

        -- Create and write to file
        Deno.writeTextFile mempty testFile testContent

        -- Open file for reading
        file <- Deno.open (OpenOptions.read true) testFile

        -- Create a small buffer (only 10 bytes)
        buffer <- liftEffect $ Typed.empty 10

        -- Read from file
        bytesRead <- FsFile.read buffer file

        -- Should have read exactly 10 bytes (buffer size)
        bytesRead `shouldEqual` (Just 10)

        -- Close file
        liftEffect $ FsFile.close file

        -- Clean up
        Deno.remove false testFile

      it "should handle reading from empty file" do
        let testFile = "/tmp/test-fsfile-read-empty.txt"

        -- Create empty file
        file <- Deno.create testFile

        -- Create buffer
        buffer <- liftEffect $ Typed.empty 10

        -- Read from empty file
        bytesRead <- FsFile.read buffer file

        -- Should read 0 bytes or Nothing from empty file
        bytesRead `shouldSatisfy` case _ of
          Nothing -> true
          Just 0 -> true
          _ -> false

        -- Close file
        liftEffect $ FsFile.close file

        -- Clean up
        Deno.remove false testFile

      it "should work with different buffer sizes" do
        let testFile = "/tmp/test-fsfile-read-sizes.txt"
        let testContent = "Buffer size test content"

        -- Create and write to file
        Deno.writeTextFile mempty testFile testContent

        -- Test with various buffer sizes
        file1 <- Deno.open (OpenOptions.read true) testFile
        buffer1 <- liftEffect $ Typed.empty 1 -- Very small buffer
        bytesRead1 <- FsFile.read buffer1 file1
        bytesRead1 `shouldEqual` (Just 1)
        liftEffect $ FsFile.close file1

        file2 <- Deno.open (OpenOptions.read true) testFile
        buffer2 <- liftEffect $ Typed.empty 100 -- Large buffer
        bytesRead2 <- FsFile.read buffer2 file2
        -- Should read the actual content length (24 bytes for our test content)
        let actualBytesRead2 = fromMaybe 0 bytesRead2
        actualBytesRead2 `shouldSatisfy` (_ > 0)
        actualBytesRead2 `shouldSatisfy` (_ <= 100)
        liftEffect $ FsFile.close file2

        -- Clean up
        Deno.remove false testFile

      it "should handle multiple reads from same file" do
        let testFile = "/tmp/test-fsfile-read-multiple.txt"
        let testContent = "Multiple reads test content here"

        -- Create and write to file
        Deno.writeTextFile mempty testFile testContent

        -- Open file for reading
        file <- Deno.open (OpenOptions.read true) testFile

        -- First read
        buffer1 <- liftEffect $ Typed.empty 10
        bytesRead1 <- FsFile.read buffer1 file
        bytesRead1 `shouldEqual` (Just 10)

        -- Second read (should continue from where first read left off)
        buffer2 <- liftEffect $ Typed.empty 10
        bytesRead2 <- FsFile.read buffer2 file
        let actualBytesRead2 = fromMaybe 0 bytesRead2
        actualBytesRead2 `shouldSatisfy` (_ > 0)

        -- Close file
        liftEffect $ FsFile.close file

        -- Clean up
        Deno.remove false testFile
