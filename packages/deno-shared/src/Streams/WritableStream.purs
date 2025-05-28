module Web.Streams.WritableStream
  ( WritableStream
  , locked
  , abort
  , close
  , getWriter
  ) where

import Prelude

-- Remove unused import
-- import Data.Either (Either(..))
import Data.Maybe (Maybe)
import Data.Nullable (Nullable, toNullable)
import Effect (Effect)
import Effect.Aff (Aff)
import Deno.Util (runAsyncEffect1, runAsyncEffect2)
import Effect.Exception (Error)
import Effect.Uncurried (EffectFn1, EffectFn3, EffectFn4, runEffectFn1)
import Web.Streams.Writer (Writer)

-- WritableStream is a higher-kinded type that takes a chunk type parameter
foreign import data WritableStream :: Type -> Type

-- Properties
foreign import _locked :: forall chunk. EffectFn1 (WritableStream chunk) Boolean

locked :: forall chunk. WritableStream chunk -> Effect Boolean
locked = runEffectFn1 _locked

-- Methods

foreign import _abort :: forall chunk. EffectFn4 (WritableStream chunk) (Nullable String) (EffectFn1 Unit Unit) (EffectFn1 Error Unit) Unit

abort :: forall chunk. Maybe String -> WritableStream chunk -> Aff Unit
abort reason stream = runAsyncEffect2 _abort stream (toNullable reason)


foreign import _close :: forall chunk. EffectFn3 (WritableStream chunk) (EffectFn1 Unit Unit) (EffectFn1 Error Unit) Unit

close :: forall chunk. WritableStream chunk -> Aff Unit
close stream = runAsyncEffect1 _close stream

foreign import _getWriter :: forall chunk. EffectFn1 (WritableStream chunk) (Writer chunk)

getWriter :: forall chunk. WritableStream chunk -> Effect (Writer chunk)
getWriter = runEffectFn1 _getWriter
