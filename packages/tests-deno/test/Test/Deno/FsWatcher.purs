module Test.Deno.FsWatcher where

import Prelude

import Data.Array as Array
import Deno.FileSystem (writeTextFile, watchFs) as Deno
import Deno.FileSystem.FsWatcher (fsWatcherClose, watch, fsEventPaths)
import Deno.FileSystem.WriteFileOptions as WriteFileOptions
import Effect.Aff (delay)
import Effect.Class (liftEffect)
import Effect.Ref as Ref
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)
import Data.Time.Duration (Milliseconds(..))

spec :: Spec Unit
spec = do
  describe "FsWatcher" do
    describe "File system watching" do
      it "should create a file system watcher" do
        let testDir = "/tmp"

        -- Create a watcher for the test directory
        watcher <- liftEffect $ Deno.watchFs [testDir] false

        -- Verify we got a watcher (basic test)
        -- We can't easily test the type, but we can test it doesn't crash
        pure unit

        -- Close the watcher
        liftEffect $ fsWatcherClose watcher

      it "should watch multiple paths" do
        let testDirs = ["/tmp", "/var/tmp"]

        -- Create watcher for multiple paths
        watcher <- liftEffect $ Deno.watchFs testDirs false

        -- Basic test - verify creation doesn't crash
        pure unit

        -- Close the watcher
        liftEffect $ fsWatcherClose watcher

    describe "FsWatcher operations" do
      it "should close a file system watcher" do
        let testDir = "/tmp"

        -- Create a watcher
        watcher <- liftEffect $ Deno.watchFs [testDir] false

        -- Close the watcher (should not throw)
        liftEffect $ fsWatcherClose watcher

        -- Test passes if no exception is thrown
        pure unit
        
      it "should watch for file system events" do
        let testDir = "/tmp"
        let testFile = "/tmp/fs-watcher-test-file.txt"
        
        -- Create a watcher
        watcher <- liftEffect $ Deno.watchFs [testDir] false
        
        -- Create a ref to track if we got an event
        eventsRef <- liftEffect $ Ref.new []
        
        -- Start watching for events
        stopWatching <- liftEffect $ watch (\event -> do
          paths <- fsEventPaths event
          -- Add paths to our events array
          _ <- Ref.modify (\events -> events <> paths) eventsRef
          pure unit
        ) watcher
        
        -- Create a test file to trigger the watcher
        _ <- Deno.writeTextFile (WriteFileOptions.create true) testFile "Testing file system watcher"
        
        -- Wait a bit for the event to be processed
        delay (Milliseconds 500.0)
        
        -- Get events that were collected
        events <- liftEffect $ Ref.read eventsRef
        
        -- Check if we got an event containing our test file path
        let containsTestFile = Array.any (eq testFile) events
        containsTestFile `shouldEqual` true
        
        -- Clean up by stopping the watch and closing the watcher
        liftEffect $ stopWatching
        liftEffect $ fsWatcherClose watcher
