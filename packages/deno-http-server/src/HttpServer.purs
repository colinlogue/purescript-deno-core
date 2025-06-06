module Deno.HttpServer
  ( HttpServer
  , ServeHandler
  , ServeHandlerInfo
  , serveNet
  , serveUnix
  , serveVsock
  , ServeTcpOptions
  , ServeTlsOptions
  , ServeUnixOptions
  , ServeVsockOptions
  , serveTcp
  , serveTls
  , AbortSignal
  , finished
  , addr
  , ref
  , unref
  , shutdown
  ) where

import Prelude

import Control.Promise (Promise)
import Control.Promise as Promise
import Data.Maybe (Maybe)
import Data.Nullable (Nullable, toNullable)
import Deno.HttpServer.Addr (NetAddr, NetAddrInfo, UnixAddr, UnixAddrInfo, VsockAddr, VsockAddrInfo, netAddrInfo, unixAddrInfo, vsockAddrInfo)
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Effect.Uncurried (EffectFn1, EffectFn2, EffectFn3, mkEffectFn2, runEffectFn1, runEffectFn2, runEffectFn3)
import Web.Fetch.Request (Request)
import Web.Fetch.Response (Response)


foreign import data HttpServer :: Type -> Type

type ServeHandlerInfo addr =
  { remoteAddr :: addr
  , completed :: Promise Unit
  }

type ServeHandler addr = ServeHandlerInfo addr -> Request -> Aff Response

type ServeHandlerRaw a = EffectFn2 Request (ServeHandlerInfo a) (Promise Response)

-- | Options for TCP server
type ServeTcpOptions =
  { port :: Number -- Optional, defaults to 8000
  , hostname :: String -- Optional, defaults to "0.0.0.0"
  , reusePort :: Boolean -- Optional
  , signal :: Nullable AbortSignal -- Optional, used to abort the server
  }

-- | Options for TLS server (extends TCP options)
type ServeTlsOptions =
  { port :: Number -- Optional, defaults to 8443
  , hostname :: String -- Optional, defaults to "0.0.0.0"
  , reusePort :: Boolean -- Optional
  , signal :: Nullable AbortSignal -- Optional, used to abort the server
  , cert :: String -- Certificate file content as string
  , key :: String -- Private key file content as string
  }

-- | Options for Unix domain socket server
type ServeUnixOptions =
  { path :: String
  , transport :: Nullable String -- Optional, "unix" or null
  , reusePort :: Boolean -- Optional
  , signal :: Nullable AbortSignal -- Optional, used to abort the server
  }

-- | Options for Vsock server
type ServeVsockOptions =
  { cid :: Number -- Client ID
  , port :: Number
  , signal :: Nullable AbortSignal -- Optional, used to abort the server
  }

foreign import data AbortSignal :: Type

foreign import _serveNet :: EffectFn1 (ServeHandlerRaw NetAddr) (HttpServer NetAddrInfo)

foreign import _serveUnix :: EffectFn3 (Nullable String) String (ServeHandlerRaw UnixAddr) (HttpServer UnixAddrInfo)

foreign import _serveVsock :: EffectFn2 ServeVsockOptions (ServeHandlerRaw VsockAddr) (HttpServer VsockAddrInfo)

foreign import _serveTcp :: forall r. EffectFn2 { | r } (ServeHandlerRaw NetAddr) (HttpServer NetAddrInfo)

serveNet :: ServeHandler NetAddrInfo -> Effect (HttpServer NetAddrInfo)
serveNet handler =
  let
    serveHandlerRaw :: ServeHandlerRaw NetAddr
    serveHandlerRaw =
      mkEffectFn2 \req info ->
        Promise.fromAff $ handler (info { remoteAddr = netAddrInfo (info.remoteAddr) }) req
  in
    runEffectFn1 _serveNet serveHandlerRaw

serveUnix :: Maybe String -> String -> ServeHandler UnixAddrInfo -> Effect (HttpServer UnixAddrInfo)
serveUnix transport path handler =
  let
    serveHandlerRaw :: ServeHandlerRaw UnixAddr
    serveHandlerRaw =
      mkEffectFn2 \req info ->
        Promise.fromAff $ handler (info { remoteAddr = unixAddrInfo (info.remoteAddr) }) req
  in
    runEffectFn3 _serveUnix (toNullable transport) path serveHandlerRaw

serveVsock :: ServeVsockOptions -> ServeHandler VsockAddrInfo -> Effect (HttpServer VsockAddrInfo)
serveVsock options handler =
  let
    serveHandlerRaw :: ServeHandlerRaw VsockAddr
    serveHandlerRaw =
      mkEffectFn2 \req info ->
        Promise.fromAff $ handler (info { remoteAddr = vsockAddrInfo (info.remoteAddr) }) req
  in
    runEffectFn2 _serveVsock options serveHandlerRaw

serveTcp :: forall r. { port :: Number, hostname :: String, reusePort :: Boolean, signal :: Nullable AbortSignal | r } -> ServeHandler NetAddrInfo -> Effect (HttpServer NetAddrInfo)
serveTcp options handler =
  let
    serveHandlerRaw :: ServeHandlerRaw NetAddr
    serveHandlerRaw =
      mkEffectFn2 \req info ->
        Promise.fromAff $ handler (info { remoteAddr = netAddrInfo (info.remoteAddr) }) req
  in
    runEffectFn2 _serveTcp options serveHandlerRaw

-- | Same as serveTcp but for TLS connections (semantically)
serveTls :: ServeTlsOptions -> ServeHandler NetAddrInfo -> Effect (HttpServer NetAddrInfo)
serveTls = serveTcp

-- | Returns a promise that resolves when the server finishes processing all
-- | pending requests and closes all connections
foreign import _finished :: forall a. EffectFn1 (HttpServer a) (Promise Unit)

-- | Returns the server's address information
foreign import _addr :: forall a. (HttpServer a) -> a

-- | Add a reference to the server to keep the event loop running
foreign import _ref :: forall a. EffectFn1 (HttpServer a) Unit

-- | Remove a reference from the server, allowing the event loop to exit
foreign import _unref :: forall a. EffectFn1 (HttpServer a) Unit

-- | Shuts down the server
foreign import _shutdown :: forall a. EffectFn1 (HttpServer a) (Promise Unit)

-- | Returns a promise that resolves when the server finishes processing all
-- | pending requests and closes all connections
finished :: forall a. HttpServer a -> Aff Unit
finished server = liftEffect (runEffectFn1 _finished server) >>= Promise.toAff

-- | Returns the server's address information
addr :: forall a. HttpServer a -> a
addr server = _addr server

-- | Add a reference to the server to keep the event loop running
ref :: forall a. HttpServer a -> Effect Unit
ref = runEffectFn1 _ref

-- | Remove a reference from the server, allowing the event loop to exit
unref :: forall a. HttpServer a -> Effect Unit
unref = runEffectFn1 _unref

-- | Shuts down the server
shutdown :: forall a. HttpServer a -> Aff Unit
shutdown server = liftEffect (runEffectFn1 _shutdown server) >>= Promise.toAff
