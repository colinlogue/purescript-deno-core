module Deno.HttpServer.Addr where

import Data.Function.Uncurried (Fn2, Fn3, runFn2, runFn3)


foreign import data NetAddr :: Type

foreign import data UnixAddr :: Type

foreign import data VsockAddr :: Type

foreign import _netAddr :: Fn3 String String Number NetAddr

foreign import _unixAddr :: Fn2 String String UnixAddr

foreign import _vsockAddr :: Fn2 Number Number VsockAddr

foreign import _netAddrInfo :: Fn3 NetAddr NetAddrTransport NetAddrTransport NetAddrInfo

foreign import _unixAddrInfo :: Fn3 UnixAddr UnixAddrTransport UnixAddrTransport UnixAddrInfo

foreign import _vsockAddrInfo :: VsockAddr -> VsockAddrInfo

data NetAddrTransport
  = TCP
  | UDP

data UnixAddrTransport
  = Unix
  | UnixPacket

type NetAddrInfo =
  { transport :: NetAddrTransport
  , host :: String
  , port :: Number
  }

type UnixAddrInfo =
  { transport :: UnixAddrTransport
  , path :: String
  }

type VsockAddrInfo =
  { cid :: Number
  , port :: Number
  }

netAddr :: NetAddrTransport -> String -> Number -> NetAddr
netAddr transport host port =
  let
    transportStr = case transport of
      TCP -> "tcp"
      UDP -> "udp"
  in
    runFn3 _netAddr transportStr host port


unixAddr :: UnixAddrTransport -> String -> UnixAddr
unixAddr transport path =
  let
    transportStr = case transport of
      Unix -> "unix"
      UnixPacket -> "unixpacket"
  in
    runFn2 _unixAddr transportStr path

vsockAddr :: Number -> Number -> VsockAddr
vsockAddr cid port = runFn2 _vsockAddr cid port

netAddrInfo :: NetAddr -> NetAddrInfo
netAddrInfo addr = runFn3 _netAddrInfo addr TCP UDP

unixAddrInfo :: UnixAddr -> UnixAddrInfo
unixAddrInfo addr = runFn3 _unixAddrInfo addr Unix UnixPacket

vsockAddrInfo :: VsockAddr -> VsockAddrInfo
vsockAddrInfo = _vsockAddrInfo
