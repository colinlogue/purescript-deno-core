module Test.Deno.FsWatcher where

import Prelude

import Deno.FileSystem (watchFs) as Deno
import Deno.FileSystem.FsWatcher (fsWatcherClose)
import Effect.Class (liftEffect)
import Test.Spec (Spec, describe, it)

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