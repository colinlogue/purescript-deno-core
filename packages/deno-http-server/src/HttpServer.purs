module Deno.HttpServer
  ( HttpServer
  , ServeHandler
  , ServeHandlerInfo
  , serveNet
  ) where

import Prelude

import Control.Promise (Promise)
import Control.Promise as Promise
import Deno.HttpServer.Addr (NetAddr, NetAddrInfo, netAddrInfo)
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Uncurried (EffectFn1, EffectFn2, mkEffectFn2, runEffectFn1)
import JS.Fetch.Request (Request)
import JS.Fetch.Response (Response)


foreign import data HttpServer :: Type -> Type

type ServeHandlerInfo addr =
  { remoteAddr :: addr
  , completed :: Promise Unit
  }

type ServeHandler addr = ServeHandlerInfo addr -> Request -> Aff Response

type ServeHandlerRaw a = EffectFn2 Request (ServeHandlerInfo a) (Promise Response)

foreign import _serveNet :: EffectFn1 (ServeHandlerRaw NetAddr) (HttpServer NetAddrInfo)

serveNet :: ServeHandler NetAddrInfo -> Effect (HttpServer NetAddrInfo)
serveNet handler =
  let
    serveHandlerRaw :: ServeHandlerRaw NetAddr
    serveHandlerRaw =
      mkEffectFn2 \req info ->
        Promise.fromAff $ handler (info { remoteAddr = netAddrInfo (info.remoteAddr) }) req
  in
    runEffectFn1 _serveNet serveHandlerRaw
