module Web.Streams.WritableStream
  ( WritableStream
  , locked
  , abort
  , close
  , getWriter
  ) where

import Prelude

import Data.Either (Either(..))
import Data.Maybe (Maybe)
import Data.Nullable (Nullable, toNullable)
import Effect (Effect)
import Effect.Aff (Aff, makeAff)
import Effect.Exception (Error)
import Effect.Uncurried (EffectFn1, EffectFn3, EffectFn4, mkEffectFn1, runEffectFn1, runEffectFn3, runEffectFn4)
import Web.Streams.Writer (Writer)

-- WritableStream is a higher-kinded type that takes a chunk type parameter
foreign import data WritableStream :: Type -> Type

-- Properties
foreign import _locked :: forall chunk. EffectFn1 (WritableStream chunk) Boolean

locked :: forall chunk. WritableStream chunk -> Effect Boolean
locked = runEffectFn1 _locked

-- Methods
foreign import _abort :: forall chunk. EffectFn4 (WritableStream chunk) (Nullable String) (Effect Unit) (EffectFn1 Error Unit) Unit

abort :: forall chunk. Maybe String -> WritableStream chunk -> Aff Unit
abort reason stream = makeAff \cb ->
  let
    onSuccess = cb (Right unit)
    onError = cb <<< Left
  in
    runEffectFn4 _abort stream (toNullable reason) onSuccess (mkEffectFn1 onError) *> mempty

foreign import _close :: forall chunk. EffectFn3 (WritableStream chunk) (Effect Unit) (EffectFn1 Error Unit) Unit

close :: forall chunk. WritableStream chunk -> Aff Unit
close stream = makeAff \cb ->
  let
    onSuccess = cb (Right unit)
    onError = cb <<< Left
  in
    runEffectFn3 _close stream onSuccess (mkEffectFn1 onError) *> mempty

foreign import _getWriter :: forall chunk. EffectFn1 (WritableStream chunk) (Writer chunk)

getWriter :: forall chunk. WritableStream chunk -> Effect (Writer chunk)
getWriter = runEffectFn1 _getWriter
