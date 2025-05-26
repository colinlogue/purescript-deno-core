module Test.Deno.HttpServer where

import Prelude

import Data.Maybe (Maybe(..))
import Deno.HttpServer as HttpServer
import Effect.Aff (Aff)
import JS.Fetch.Request (Request)
import JS.Fetch.Response (Response)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual, shouldNotEqual)

-- FFI to create a Response
foreign import createResponse :: String -> Response

-- FFI to get response status
foreign import getResponseStatus :: Response -> Int

-- Mock handler that always returns a 200 OK response with "Hello, World!" text
mockHandler :: forall a. a -> Request -> Aff Response
mockHandler _ _ = pure $ createResponse "Hello, World!"

-- Main spec for testing Deno.HttpServer
spec :: Spec Unit
spec = describe "Deno.HttpServer" do
  describe "HttpServer type" do
    it "should be defined" do
      let _ = (Nothing :: Maybe (HttpServer.HttpServer Unit))
      true `shouldEqual` true

  describe "HTTP Response" do
    it "can create a Response with default status" do
      let response = createResponse "Hello, World!"
      getResponseStatus response `shouldEqual` 200

  describe "serveNet" do
    it "exports a serveNet function" do
      -- Just verify the function exists and has the expected type
      let _ = HttpServer.serveNet
      true `shouldEqual` true

  describe "serveUnix" do
    it "exports a serveUnix function" do
      -- Just verify the function exists and has the expected type
      let _ = HttpServer.serveUnix
      true `shouldEqual` true

  describe "serveVsock" do
    it "exports a serveVsock function" do
      -- Just verify the function exists and has the expected type
      let _ = HttpServer.serveVsock
      true `shouldEqual` true

  describe "serveTcp" do
    it "exports a serveTcp function" do
      -- Just verify the function exists and has the expected type
      let _ = HttpServer.serveTcp
      true `shouldEqual` true

  describe "serveTls" do
    it "exports a serveTls function" do
      -- Just verify the function exists and has the expected type
      let _ = HttpServer.serveTls
      true `shouldEqual` true
      
  describe "finished" do
    it "exports a finished function" do
      -- Just verify the function exists and has the expected type
      let _ = HttpServer.finished
      true `shouldEqual` true

  describe "addr" do
    it "exports an addr function" do
      -- Just verify the function exists and has the expected type
      let _ = HttpServer.addr
      true `shouldEqual` true

  describe "ref" do
    it "exports a ref function" do
      -- Just verify the function exists and has the expected type
      let _ = HttpServer.ref
      true `shouldEqual` true

  describe "unref" do
    it "exports an unref function" do
      -- Just verify the function exists and has the expected type
      let _ = HttpServer.unref
      true `shouldEqual` true

  describe "shutdown" do
    it "exports a shutdown function" do
      -- Just verify the function exists and has the expected type
      let _ = HttpServer.shutdown
      true `shouldEqual` true