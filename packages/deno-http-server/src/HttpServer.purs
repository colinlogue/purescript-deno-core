module Deno.HttpServer
  ( ServeInit
  , ServeTlsInit
  , ConnInfo
  , Server
  , Handler
  , serve
  , serveTls
  , createServer
  , createServerTls
  , listenAndServe
  , serverFinished
  , closeServer
  ) where

import Prelude

import Control.Promise (Promise)
import Control.Promise as Promise
import Data.Function.Uncurried (mkEffectFn1)
import Deno.HttpServer.Foreign (Foreign, unsafeToForeign)
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Uncurried (EffectFn1, EffectFn2, runEffectFn1, runEffectFn2)

-- | Type for HTTP request handler function
type Handler = Request -> Aff Response

-- | Configuration options for HTTP server
type ServeInit =
  { port :: Int -- Optional, defaults to 8000 in Deno
  , hostname :: String -- Optional, defaults to "0.0.0.0" in Deno
  , handler :: Handler -- The request handler function
  , onListen :: ConnInfo -> Effect Unit -- Optional, called when the server starts listening
  , onError :: Error -> Effect Response -- Optional, called when an error occurs
  , signal :: AbortSignal -- Optional, used to abort the server
  }

-- | Configuration options for HTTPS server
type ServeTlsInit =
  { port :: Int -- Optional, defaults to 8443 in Deno
  , hostname :: String -- Optional, defaults to "0.0.0.0" in Deno
  , handler :: Handler -- The request handler function
  , onListen :: ConnInfo -> Effect Unit -- Optional, called when the server starts listening
  , onError :: Error -> Effect Response -- Optional, called when an error occurs
  , signal :: AbortSignal -- Optional, used to abort the server
  , cert :: String -- Certificate file as string
  , key :: String -- Key file as string
  }

-- | Connection information provided to onListen callback
type ConnInfo =
  { hostname :: String
  , port :: Int
  , transport :: String -- "tcp" or "unix"
  }

-- | HTTP server instance type
foreign import data Server :: Type

-- | HTTP request type (from Web API)
foreign import data Request :: Type

-- | HTTP response type (from Web API)
foreign import data Response :: Type

-- | Signal for aborting operations (from Web API)
foreign import data AbortSignal :: Type

-- | Error type
foreign import data Error :: Type

-- | Start an HTTP server with the given handler and options
foreign import _serve :: EffectFn2 Foreign (EffectFn1 Request (Promise Response)) (Promise Unit)

serve :: ServeInit -> Aff Unit
serve options = Promise.toAffE $ runEffectFn2 _serve (unsafeToForeign options) (mkEffectFn1 handlerFn)
  where
    handlerFn :: Request -> Effect (Promise Response)
    handlerFn req = Promise.fromAff $ options.handler req

-- | Start an HTTPS server with the given handler and options
foreign import _serveTls :: EffectFn2 Foreign (EffectFn1 Request (Promise Response)) (Promise Unit)

serveTls :: ServeTlsInit -> Aff Unit
serveTls options = Promise.toAffE $ runEffectFn2 _serveTls (unsafeToForeign options) (mkEffectFn1 handlerFn)
  where
    handlerFn :: Request -> Effect (Promise Response)
    handlerFn req = Promise.fromAff $ options.handler req

-- | Create a server instance without starting it
foreign import _createServer :: EffectFn2 Foreign (EffectFn1 Request (Promise Response)) Server

createServer :: ServeInit -> Effect Server
createServer options = runEffectFn2 _createServer (unsafeToForeign options) (mkEffectFn1 handlerFn)
  where
    handlerFn :: Request -> Effect (Promise Response)
    handlerFn req = Promise.fromAff $ options.handler req

-- | Create a TLS server instance without starting it
foreign import _createServerTls :: EffectFn2 Foreign (EffectFn1 Request (Promise Response)) Server

createServerTls :: ServeTlsInit -> Effect Server
createServerTls options = runEffectFn2 _createServerTls (unsafeToForeign options) (mkEffectFn1 handlerFn)
  where
    handlerFn :: Request -> Effect (Promise Response)
    handlerFn req = Promise.fromAff $ options.handler req

-- | Start a server that was created with createServer
foreign import _listenAndServe :: EffectFn1 Server (Promise Unit)

listenAndServe :: Server -> Aff Unit
listenAndServe server = Promise.toAffE $ runEffectFn1 _listenAndServe server

-- | Get the finished promise from a server
foreign import _serverFinished :: EffectFn1 Server (Promise Unit)

serverFinished :: Server -> Aff Unit
serverFinished server = Promise.toAffE $ runEffectFn1 _serverFinished server

-- | Close a server
foreign import _closeServer :: EffectFn1 Server (Promise Unit)

closeServer :: Server -> Aff Unit
closeServer server = Promise.toAffE $ runEffectFn1 _closeServer server

