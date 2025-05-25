module Test.Deno.FsFile where

import Prelude

import Deno as Deno
import Deno.FsFile as FsFile
import Effect.Class (liftEffect)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

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
