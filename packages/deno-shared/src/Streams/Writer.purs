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

-- Remove unused import
import Data.Maybe (Maybe)
import Data.Nullable (Nullable, toNullable)
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Exception (Error)
import Effect.Uncurried (EffectFn1, EffectFn3, EffectFn4, runEffectFn1)
import Deno.Util (runAsyncEffect1, runAsyncEffect2)

-- Writer is a higher-kinded type that takes a chunk type parameter
foreign import data Writer :: Type -> Type

-- Methods
foreign import _write :: forall chunk. EffectFn4 (Writer chunk) chunk (EffectFn1 Unit Unit) (EffectFn1 Error Unit) Unit

write :: forall chunk. chunk -> Writer chunk -> Aff Unit
write chunk writer = runAsyncEffect2 _write writer chunk

foreign import _close :: forall chunk. EffectFn3 (Writer chunk) (EffectFn1 Unit Unit) (EffectFn1 Error Unit) Unit

close :: forall chunk. Writer chunk -> Aff Unit
close writer = runAsyncEffect1 _close writer

foreign import _abort :: forall chunk. EffectFn4 (Writer chunk) (Nullable String) (EffectFn1 Unit Unit) (EffectFn1 Error Unit) Unit

abort :: forall chunk. Maybe String -> Writer chunk -> Aff Unit
abort reason writer = runAsyncEffect2 _abort writer (toNullable reason)

foreign import _releaseLock :: forall chunk. EffectFn1 (Writer chunk) Unit

releaseLock :: forall chunk. Writer chunk -> Effect Unit
releaseLock = runEffectFn1 _releaseLock

-- Properties (Promises converted to Aff)
foreign import _closed :: forall chunk. EffectFn3 (Writer chunk) (EffectFn1 Unit Unit) (EffectFn1 Error Unit) Unit

closed :: forall chunk. Writer chunk -> Aff Unit
closed writer = runAsyncEffect1 _closed writer

foreign import _ready :: forall chunk. EffectFn3 (Writer chunk) (EffectFn1 Unit Unit) (EffectFn1 Error Unit) Unit

ready :: forall chunk. Writer chunk -> Aff Unit
ready writer = runAsyncEffect1 _ready writer
