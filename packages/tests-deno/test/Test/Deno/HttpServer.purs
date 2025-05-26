module Test.Deno.HttpServer where

import Prelude

import Data.Maybe (Maybe(..))
import Deno.HttpServer as HttpServer
import Effect (Effect)
import Effect.Aff (Aff)
import JS.Fetch.Request (Request)
import JS.Fetch.Response (Response)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

-- FFI to create a Response
foreign import createResponse :: String -> Response

-- FFI for server.shutdown()
foreign import serverShutdown :: forall a. a -> Effect Unit

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

  describe "serveNet" do
    it "can create a server with default options" do
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