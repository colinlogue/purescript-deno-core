module Deno.Runtime.Env
  ( Env
  , get
  , set
  , delete
  , has
  , toObject
  ) where

import Prelude

import Data.Maybe (Maybe)
import Data.Nullable (Nullable)
import Data.Nullable as Nullable
import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn2, EffectFn3, runEffectFn1, runEffectFn2, runEffectFn3)
import Foreign.Object (Object)

-- | The Deno.Env interface for interacting with environment variables
foreign import data Env :: Type

-- | Get the value of an environment variable
-- | Returns Nothing if the variable is not defined
foreign import _get :: EffectFn2 Env String (Nullable String)

get :: Env -> String -> Effect (Maybe String)
get env key = do
  result <- runEffectFn2 _get env key
  pure $ Nullable.toMaybe result

-- | Set the value of an environment variable
foreign import _set :: EffectFn3 Env String String Unit

set :: Env -> String -> String -> Effect Unit
set env key value = runEffectFn3 _set env key value

-- | Delete an environment variable
foreign import _delete :: EffectFn2 Env String Unit

delete :: Env -> String -> Effect Unit
delete env key = runEffectFn2 _delete env key

-- | Check if an environment variable exists
foreign import _has :: EffectFn2 Env String Boolean

has :: Env -> String -> Effect Boolean
has env key = runEffectFn2 _has env key

-- | Get all environment variables as an object
foreign import _toObject :: EffectFn1 Env (Object String)

toObject :: Env -> Effect (Object String)
toObject env = runEffectFn1 _toObject env
