module Web.Streams.Writer
  ( Writer
  , write
  , close
  , abort
  , closed
  , ready
  , releaseLock
  ) where

import Prelude

import Data.Either (Either(..))
import Data.Maybe (Maybe)
import Data.Nullable (Nullable, toNullable)
import Effect (Effect)
import Effect.Aff (Aff, makeAff)
import Effect.Exception (Error)
import Effect.Uncurried (EffectFn1, EffectFn3, EffectFn4, mkEffectFn1, runEffectFn1, runEffectFn3, runEffectFn4)

-- Writer is a higher-kinded type that takes a chunk type parameter
foreign import data Writer :: Type -> Type

-- Methods
foreign import _write :: forall chunk. EffectFn4 (Writer chunk) chunk (Effect Unit) (EffectFn1 Error Unit) Unit

write :: forall chunk. chunk -> Writer chunk -> Aff Unit
write chunk writer = makeAff \cb ->
  let
    onSuccess = cb (Right unit)
    onError = cb <<< Left
  in
    runEffectFn4 _write writer chunk onSuccess (mkEffectFn1 onError) *> mempty

foreign import _close :: forall chunk. EffectFn3 (Writer chunk) (Effect Unit) (EffectFn1 Error Unit) Unit

close :: forall chunk. Writer chunk -> Aff Unit
close writer = makeAff \cb ->
  let
    onSuccess = cb (Right unit)
    onError = cb <<< Left
  in
    runEffectFn3 _close writer onSuccess (mkEffectFn1 onError) *> mempty

foreign import _abort :: forall chunk. EffectFn4 (Writer chunk) (Nullable String) (Effect Unit) (EffectFn1 Error Unit) Unit

abort :: forall chunk. Maybe String -> Writer chunk -> Aff Unit
abort reason writer = makeAff \cb ->
  let
    onSuccess = cb (Right unit)
    onError = cb <<< Left
  in
    runEffectFn4 _abort writer (toNullable reason) onSuccess (mkEffectFn1 onError) *> mempty

foreign import _releaseLock :: forall chunk. EffectFn1 (Writer chunk) Unit

releaseLock :: forall chunk. Writer chunk -> Effect Unit
releaseLock = runEffectFn1 _releaseLock

-- Properties (Promises converted to Aff)
foreign import _closed :: forall chunk. EffectFn3 (Writer chunk) (Effect Unit) (EffectFn1 Error Unit) Unit

closed :: forall chunk. Writer chunk -> Aff Unit
closed writer = makeAff \cb ->
  let
    onSuccess = cb (Right unit)
    onError = cb <<< Left
  in
    runEffectFn3 _closed writer onSuccess (mkEffectFn1 onError) *> mempty

foreign import _ready :: forall chunk. EffectFn3 (Writer chunk) (Effect Unit) (EffectFn1 Error Unit) Unit

ready :: forall chunk. Writer chunk -> Aff Unit
ready writer = makeAff \cb ->
  let
    onSuccess = cb (Right unit)
    onError = cb <<< Left
  in
    runEffectFn3 _ready writer onSuccess (mkEffectFn1 onError) *> mempty
