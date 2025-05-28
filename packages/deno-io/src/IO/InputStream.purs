module Deno.IO.InputStream
  ( InputStream
  , readable
  , read
  , readSync
  , close
  ) where

import Prelude

import Data.ArrayBuffer.Types (Uint8Array)
import Data.Maybe (Maybe)
import Data.Nullable (Nullable)
import Data.Nullable as Nullable
import Deno.Util (runAsyncEffect2)
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Exception (Error)
import Effect.Uncurried (EffectFn1, EffectFn2, EffectFn4, runEffectFn1, runEffectFn2)
import Web.Streams.ReadableStream (ReadableStream)

foreign import data InputStream :: Type

foreign import _readable :: InputStream -> ReadableStream Uint8Array

foreign import _read :: EffectFn4 InputStream Uint8Array (EffectFn1 (Nullable Int) Unit) (EffectFn1 Error Unit) Unit

foreign import _readSync :: EffectFn2 InputStream Uint8Array (Nullable Int)

foreign import _close :: EffectFn1 InputStream Unit


readable :: InputStream -> ReadableStream Uint8Array
readable = _readable

read :: Uint8Array -> InputStream -> Aff (Maybe Int)
read buffer stream = Nullable.toMaybe <$> runAsyncEffect2 _read stream buffer

readSync :: Uint8Array -> InputStream -> Effect (Maybe Int)
readSync buffer stream = Nullable.toMaybe <$> runEffectFn2 _readSync stream buffer

close :: InputStream -> Effect Unit
close = runEffectFn1 _close
