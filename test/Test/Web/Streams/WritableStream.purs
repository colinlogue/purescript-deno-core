module Test.Web.Streams.WritableStream where

import Prelude

import Data.ArrayBuffer.Types (Uint8Array)
import Data.Maybe (Maybe(..))
import Deno as Deno
import Deno.FsFile as FsFile
import Effect.Class (liftEffect)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)
import Web.Streams.WritableStream as WritableStream
import Web.Streams.Writer as Writer

foreign import encodeText :: String -> Uint8Array

spec :: Spec Unit
spec = do
  describe "WritableStream" do
    describe "Properties" do
      it "should report locked status correctly" do
        let testFile = "/tmp/test-writable-stream-locked.txt"

        -- Create file and get writable stream
        file <- Deno.create testFile
        stream <- liftEffect $ FsFile.writable file

        -- Initially should not be locked
        locked1 <- liftEffect $ WritableStream.locked stream
        locked1 `shouldEqual` false

        -- Get writer (this should lock the stream)
        writer <- liftEffect $ WritableStream.getWriter stream
        locked2 <- liftEffect $ WritableStream.locked stream
        locked2 `shouldEqual` true

        -- Release lock
        liftEffect $ Writer.releaseLock writer
        locked3 <- liftEffect $ WritableStream.locked stream
        locked3 `shouldEqual` false

        -- Clean up
        liftEffect $ FsFile.close file
        Deno.remove false testFile

    describe "Writer operations" do
      it "should write data through writer" do
        let testFile = "/tmp/test-writable-stream-write.txt"
        let testContent = "Hello WritableStream!"

        -- Create file and get writable stream
        file <- Deno.create testFile
        stream <- liftEffect $ FsFile.writable file

        -- Get writer and write data
        writer <- liftEffect $ WritableStream.getWriter stream
        let encoded = encodeText testContent
        Writer.write encoded writer
        Writer.close writer

        -- Verify content was written
        content <- Deno.readTextFile testFile
        content `shouldEqual` testContent

        -- Clean up
        Deno.remove false testFile

    describe "Stream operations" do
      it "should abort stream with reason" do
        let testFile = "/tmp/test-writable-stream-abort.txt"

        -- Create file and get writable stream
        file <- Deno.create testFile
        stream <- liftEffect $ FsFile.writable file

        -- Abort the stream with a reason
        WritableStream.abort (Nothing) stream

        -- Clean up
        Deno.remove false testFile
