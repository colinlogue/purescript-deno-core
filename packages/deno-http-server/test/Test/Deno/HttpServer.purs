module Test.Deno.HttpServer where

import Prelude

import Control.Promise (Promise)
import Data.Maybe (Maybe(..))
import Deno.HttpServer (AbortSignal, ConnInfo, ServeInit, Server, createServer, closeServer)
import Deno.HttpServer as HttpServer
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Effect.Aff as Aff
import Effect.Class (liftEffect)
import Effect.Console (log)
import Effect.Exception (error)
import Effect.Ref as Ref
import Test.Spec (Spec, describe, it, pending)
import Test.Spec.Assertions (shouldEqual)
import Web.Fetch.Request (Request)
import Web.Fetch.Response (Response)

-- Test requests and responses are not fully implemented in this test suite
-- since we'd need a web fetch API implementation and test infrastructure
foreign import mockRequest :: Effect Request
foreign import mockResponse :: Effect Response
foreign import fakeAbortSignal :: Effect AbortSignal

spec :: Spec Unit
spec = do
  describe "Deno HTTP Server" do
    describe "Server creation" do
      it "can create a server instance" do
        req <- liftEffect mockRequest
        signal <- liftEffect fakeAbortSignal
        listenCalled <- liftEffect $ Ref.new false
        
        let 
          onListen :: ConnInfo -> Effect Unit
          onListen _ = Ref.write true listenCalled
          
          handler :: Request -> Aff Response
          handler _ = liftEffect mockResponse
          
          options :: ServeInit
          options = 
            { port: 8000
            , hostname: "localhost"
            , handler
            , onListen
            , onError: \_ -> mockResponse
            , signal
            }
        
        server <- liftEffect $ createServer options
        
        -- For testing purposes, we just verify we got a server object
        -- We can't meaningfully test actual server operations in this test environment
        
        -- Close server to clean up
        -- In a real test, we would wait for server.finished
        launchAff_ $ closeServer server