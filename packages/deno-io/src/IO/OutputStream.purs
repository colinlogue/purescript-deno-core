module Deno.IO.OutputStream where

import Prelude

import Data.ArrayBuffer.Types (Uint8Array)
import Deno.Util (runAsyncEffect2)
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Exception (Error)
import Effect.Uncurried (EffectFn1, EffectFn2, EffectFn4, runEffectFn1, runEffectFn2)
import Web.Streams.WritableStream (WritableStream)


foreign import data OutputStream :: Type

foreign import _writable :: OutputStream -> WritableStream Uint8Array

foreign import _write :: EffectFn4 OutputStream Uint8Array (EffectFn1 Int Unit) (EffectFn1 Error Unit) Unit

foreign import _writeSync :: EffectFn2 OutputStream Uint8Array Int

foreign import _close :: EffectFn1 OutputStream Unit


writable :: OutputStream -> WritableStream Uint8Array
writable = _writable

write :: Uint8Array -> OutputStream -> Aff Int
write buffer stream = runAsyncEffect2 _write stream buffer

writeSync :: Uint8Array -> OutputStream -> Effect Int
writeSync buffer stream = runEffectFn2 _writeSync stream buffer

close :: OutputStream -> Effect Unit
close = runEffectFn1 _close
