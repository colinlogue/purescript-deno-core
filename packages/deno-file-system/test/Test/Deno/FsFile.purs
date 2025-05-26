module Test.Deno.FsFile where

import Prelude

import Data.ArrayBuffer.Typed as Typed
import Data.Maybe (Maybe(..), fromMaybe)
import Deno.FileSystem as Deno
import Deno.FileSystem.FsFile as FsFile
import Deno.FileSystem.OpenOptions as OpenOptions
import Effect.Class (liftEffect)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual, shouldSatisfy)
import Test.Web.Streams.WritableStream (encodeText)

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

    describe "ReadSync operations" do
      it "should read data from file synchronously into Uint8Array buffer" do
        let testFile = "/tmp/test-fsfile-readsync.txt"
        let testContent = "Hello from readSync test!"

        -- Create and write to file first
        Deno.writeTextFile mempty testFile testContent

        -- Open file for reading
        file <- Deno.open (OpenOptions.read true) testFile

        -- Create a buffer to read into (enough space for our content)
        buffer <- liftEffect $ Typed.empty 30 -- Create 30-byte buffer

        -- Read from file synchronously
        bytesRead <- liftEffect $ FsFile.readSync buffer file

        -- Should have read some bytes
        let actualBytesRead = fromMaybe 0 bytesRead
        actualBytesRead `shouldSatisfy` (_ > 0)

        -- Close file
        liftEffect $ FsFile.close file

        -- Clean up
        Deno.remove false testFile

      it "should read partial data synchronously when buffer is smaller than file" do
        let testFile = "/tmp/test-fsfile-readsync-partial.txt"
        let testContent = "This is a longer test content for partial synchronous reading"

        -- Create and write to file
        Deno.writeTextFile mempty testFile testContent

        -- Open file for reading
        file <- Deno.open (OpenOptions.read true) testFile

        -- Create a small buffer (only 10 bytes)
        buffer <- liftEffect $ Typed.empty 10

        -- Read from file synchronously
        bytesRead <- liftEffect $ FsFile.readSync buffer file

        -- Should have read exactly 10 bytes (buffer size)
        bytesRead `shouldEqual` (Just 10)

        -- Close file
        liftEffect $ FsFile.close file

        -- Clean up
        Deno.remove false testFile

      it "should handle reading from empty file synchronously" do
        let testFile = "/tmp/test-fsfile-readsync-empty.txt"

        -- Create empty file
        file <- Deno.create testFile

        -- Create buffer
        buffer <- liftEffect $ Typed.empty 10

        -- Read from empty file synchronously
        bytesRead <- liftEffect $ FsFile.readSync buffer file

        -- Should read 0 bytes or Nothing from empty file
        bytesRead `shouldSatisfy` case _ of
          Nothing -> true
          Just 0 -> true
          _ -> false

        -- Close file
        liftEffect $ FsFile.close file

        -- Clean up
        Deno.remove false testFile

      it "should work with different buffer sizes synchronously" do
        let testFile = "/tmp/test-fsfile-readsync-sizes.txt"
        let testContent = "Buffer size test content for sync"

        -- Create and write to file
        Deno.writeTextFile mempty testFile testContent

        -- Test with various buffer sizes
        file1 <- Deno.open (OpenOptions.read true) testFile
        buffer1 <- liftEffect $ Typed.empty 1 -- Very small buffer
        bytesRead1 <- liftEffect $ FsFile.readSync buffer1 file1
        bytesRead1 `shouldEqual` (Just 1)
        liftEffect $ FsFile.close file1

        file2 <- Deno.open (OpenOptions.read true) testFile
        buffer2 <- liftEffect $ Typed.empty 100 -- Large buffer
        bytesRead2 <- liftEffect $ FsFile.readSync buffer2 file2
        -- Should read the actual content length
        let actualBytesRead2 = fromMaybe 0 bytesRead2
        actualBytesRead2 `shouldSatisfy` (_ > 0)
        actualBytesRead2 `shouldSatisfy` (_ <= 100)
        liftEffect $ FsFile.close file2

        -- Clean up
        Deno.remove false testFile

      it "should handle multiple synchronous reads from same file" do
        let testFile = "/tmp/test-fsfile-readsync-multiple.txt"
        let testContent = "Multiple sync reads test content here"

        -- Create and write to file
        Deno.writeTextFile mempty testFile testContent

        -- Open file for reading
        file <- Deno.open (OpenOptions.read true) testFile

        -- First read
        buffer1 <- liftEffect $ Typed.empty 10
        bytesRead1 <- liftEffect $ FsFile.readSync buffer1 file
        bytesRead1 `shouldEqual` (Just 10)

        -- Second read (should continue from where first read left off)
        buffer2 <- liftEffect $ Typed.empty 10
        bytesRead2 <- liftEffect $ FsFile.readSync buffer2 file
        let actualBytesRead2 = fromMaybe 0 bytesRead2
        actualBytesRead2 `shouldSatisfy` (_ > 0)

        -- Close file
        liftEffect $ FsFile.close file

        -- Clean up
        Deno.remove false testFile

      it "should compare sync vs async read behavior" do
        let testFile = "/tmp/test-fsfile-sync-vs-async.txt"
        let testContent = "Sync vs async comparison test"

        -- Create and write to file
        Deno.writeTextFile mempty testFile testContent

        -- Test async read
        file1 <- Deno.open (OpenOptions.read true) testFile
        buffer1 <- liftEffect $ Typed.empty 20
        bytesReadAsync <- FsFile.read buffer1 file1
        liftEffect $ FsFile.close file1

        -- Test sync read
        file2 <- Deno.open (OpenOptions.read true) testFile
        buffer2 <- liftEffect $ Typed.empty 20
        bytesReadSync <- liftEffect $ FsFile.readSync buffer2 file2
        liftEffect $ FsFile.close file2

        -- Both should read the same amount
        bytesReadAsync `shouldEqual` bytesReadSync

        -- Clean up
        Deno.remove false testFile

    describe "Write operations" do
      it "should write data to file asynchronously" do
        let testFile = "/tmp/test-fsfile-write.txt"
        let testContent = "Hello from write test!"

        -- Create file for writing
        file <- Deno.open (OpenOptions.write true <> OpenOptions.create true) testFile

        -- Encode text to Uint8Array
        let buffer = encodeText testContent

        -- Write to file
        bytesWritten <- FsFile.write buffer file
        bytesWritten `shouldSatisfy` (_ > 0)

        -- Close file
        liftEffect $ FsFile.close file

        -- Verify content was written correctly
        content <- Deno.readTextFile testFile
        content `shouldEqual` testContent

        -- Clean up
        Deno.remove false testFile

      it "should write data to file synchronously" do
        let testFile = "/tmp/test-fsfile-writesync.txt"
        let testContent = "Hello from writeSync test!"

        -- Create file for writing
        file <- Deno.open (OpenOptions.write true <> OpenOptions.create true) testFile

        -- Encode text to Uint8Array
        let buffer = encodeText testContent

        -- Write to file synchronously
        bytesWritten <- liftEffect $ FsFile.writeSync buffer file
        bytesWritten `shouldSatisfy` (_ > 0)

        -- Close file
        liftEffect $ FsFile.close file

        -- Verify content was written correctly
        content <- Deno.readTextFile testFile
        content `shouldEqual` testContent

        -- Clean up
        Deno.remove false testFile

      it "should handle multiple writes to same file" do
        let testFile = "/tmp/test-fsfile-multi-write.txt"
        let testContent1 = "First write"
        let testContent2 = " Second write"

        -- Create file for writing
        file <- Deno.open (OpenOptions.write true <> OpenOptions.create true) testFile

        -- First write
        let buffer1 = encodeText testContent1
        bytesWritten1 <- FsFile.write buffer1 file
        bytesWritten1 `shouldSatisfy` (_ > 0)

        -- Second write (should append)
        let buffer2 = encodeText testContent2
        bytesWritten2 <- FsFile.write buffer2 file
        bytesWritten2 `shouldSatisfy` (_ > 0)

        -- Close file
        liftEffect $ FsFile.close file

        -- Verify both writes
        content <- Deno.readTextFile testFile
        content `shouldEqual` (testContent1 <> testContent2)

        -- Clean up
        Deno.remove false testFile

    describe "Seek operations" do
      it "should seek to specific position synchronously" do
        let testFile = "/tmp/test-fsfile-seeksync.txt"
        let testContent = "Hello world test content"

        -- Create and write to file
        Deno.writeTextFile mempty testFile testContent

        -- Open file for reading and writing
        file <- Deno.open (OpenOptions.read true <> OpenOptions.write true) testFile

        -- Seek to position 6 (after "Hello ")
        newPos <- liftEffect $ FsFile.seekSync 6 FsFile.seekStart file
        newPos `shouldEqual` 6

        -- Read from new position
        buffer <- liftEffect $ Typed.empty 5
        bytesRead <- FsFile.read buffer file
        bytesRead `shouldEqual` (Just 5)

        -- Close file
        liftEffect $ FsFile.close file

        -- Clean up
        Deno.remove false testFile

      it "should seek using different seek modes synchronously" do
        let testFile = "/tmp/test-fsfile-seeksync-modes.txt"
        let testContent = "0123456789" -- 10 bytes

        -- Create and write to file
        Deno.writeTextFile mempty testFile testContent

        -- Open file
        file <- Deno.open (OpenOptions.read true <> OpenOptions.write true) testFile

        -- Seek from start
        pos1 <- liftEffect $ FsFile.seekSync 3 FsFile.seekStart file
        pos1 `shouldEqual` 3

        -- Seek relative to current position
        pos2 <- liftEffect $ FsFile.seekSync 2 FsFile.seekCurrent file
        pos2 `shouldEqual` 5

        -- Seek from end
        pos3 <- liftEffect $ FsFile.seekSync (-2) FsFile.seekEnd file
        pos3 `shouldEqual` 8

        -- Close file
        liftEffect $ FsFile.close file

        -- Clean up
        Deno.remove false testFile

    describe "File synchronization operations" do
      it "should sync file data to disk" do
        let testFile = "/tmp/test-fsfile-syncdata.txt"
        let testContent = "Data to sync"

        -- Create file for writing
        file <- Deno.open (OpenOptions.write true <> OpenOptions.create true) testFile

        -- Write data
        let buffer = encodeText testContent
        _ <- FsFile.write buffer file

        -- Sync data
        FsFile.syncData file

        -- Close file
        liftEffect $ FsFile.close file

        -- Verify data was written
        content <- Deno.readTextFile testFile
        content `shouldEqual` testContent

        -- Clean up
        Deno.remove false testFile

      it "should sync file data to disk synchronously" do
        let testFile = "/tmp/test-fsfile-syncdatasync.txt"
        let testContent = "Data to sync synchronously"

        -- Create file for writing
        file <- Deno.open (OpenOptions.write true <> OpenOptions.create true) testFile

        -- Write data
        let buffer = encodeText testContent
        _ <- liftEffect $ FsFile.writeSync buffer file

        -- Sync data synchronously
        liftEffect $ FsFile.syncDataSync file

        -- Close file
        liftEffect $ FsFile.close file

        -- Verify data was written
        content <- Deno.readTextFile testFile
        content `shouldEqual` testContent

        -- Clean up
        Deno.remove false testFile

      it "should sync file and metadata synchronously" do
        let testFile = "/tmp/test-fsfile-syncsync.txt"
        let testContent = "Data and metadata to sync"

        -- Create file for writing
        file <- Deno.open (OpenOptions.write true <> OpenOptions.create true) testFile

        -- Write data
        let buffer = encodeText testContent
        _ <- liftEffect $ FsFile.writeSync buffer file

        -- Sync file and metadata synchronously
        liftEffect $ FsFile.syncSync file

        -- Close file
        liftEffect $ FsFile.close file

        -- Verify data was written
        content <- Deno.readTextFile testFile
        content `shouldEqual` testContent

        -- Clean up
        Deno.remove false testFile

    describe "File truncation operations" do
      it "should truncate file synchronously" do
        let testFile = "/tmp/test-fsfile-truncatesync.txt"
        let testContent = "This is a long content that will be truncated"

        -- Create and write to file
        Deno.writeTextFile mempty testFile testContent

        -- Open file for writing
        file <- Deno.open (OpenOptions.write true) testFile

        -- Truncate to 10 bytes
        liftEffect $ FsFile.truncateSync (Just 10) file

        -- Close file
        liftEffect $ FsFile.close file

        -- Verify truncation
        content <- Deno.readTextFile testFile
        content `shouldEqual` "This is a "

        -- Clean up
        Deno.remove false testFile

      it "should truncate entire file synchronously" do
        let testFile = "/tmp/test-fsfile-truncatesync-empty.txt"
        let testContent = "Content to be completely removed"

        -- Create and write to file
        Deno.writeTextFile mempty testFile testContent

        -- Open file for writing
        file <- Deno.open (OpenOptions.write true) testFile

        -- Truncate entire file
        liftEffect $ FsFile.truncateSync Nothing file

        -- Close file
        liftEffect $ FsFile.close file

        -- Verify file is empty
        content <- Deno.readTextFile testFile
        content `shouldEqual` ""

        -- Clean up
        Deno.remove false testFile

    describe "File timestamp operations" do
      it "should update file timestamps asynchronously" do
        let testFile = "/tmp/test-fsfile-utime.txt"
        let testContent = "File for timestamp test"

        -- Create file
        Deno.writeTextFile mempty testFile testContent

        -- Open file
        file <- Deno.open (OpenOptions.write true) testFile

        -- Update timestamps (Unix epoch: Jan 1, 2024)
        let atime = 1704067200.0 -- Access time
        let mtime = 1704067200.0 -- Modification time
        FsFile.utime atime mtime file

        -- Close file
        liftEffect $ FsFile.close file

        -- Clean up
        Deno.remove false testFile

      it "should update file timestamps synchronously" do
        let testFile = "/tmp/test-fsfile-utimesync.txt"
        let testContent = "File for sync timestamp test"

        -- Create file
        Deno.writeTextFile mempty testFile testContent

        -- Open file
        file <- Deno.open (OpenOptions.write true) testFile

        -- Update timestamps synchronously
        let atime = 1704067200.0
        let mtime = 1704067200.0
        liftEffect $ FsFile.utimeSync atime mtime file

        -- Close file
        liftEffect $ FsFile.close file

        -- Clean up
        Deno.remove false testFile