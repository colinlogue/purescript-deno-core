module Deno.Runtime
  ( chdir
  , cwd
  , execPath
  , exit
  , gid
  , hostname
  , osRelease
  , osUptime
  , uid
  , unrefTimer
  ) where

import Prelude

import Data.IsStringOrUrl (class IsStringOrUrl, StringOrUrl, toStringOrUrl)
import Data.Maybe (Maybe)
import Data.Nullable (Nullable)
import Data.Nullable as Nullable
import Effect (Effect)
import Effect.Uncurried (EffectFn1, runEffectFn1)

foreign import _chdir :: EffectFn1 StringOrUrl Unit

chdir :: forall a. IsStringOrUrl a => a -> Effect Unit
chdir path = runEffectFn1 _chdir $ toStringOrUrl path

foreign import cwd :: Effect String

foreign import execPath :: Effect String

foreign import _exit :: EffectFn1 Int Unit

exit :: Int -> Effect Unit
exit code = runEffectFn1 _exit code

foreign import _gid :: Effect (Nullable Int)

gid :: Effect (Maybe Int)
gid = Nullable.toMaybe <$> _gid

foreign import hostname :: Effect String

foreign import osRelease :: Effect String

foreign import osUptime :: Effect Number

foreign import _uid :: Effect (Nullable Int)

uid :: Effect (Maybe Int)
uid = Nullable.toMaybe <$> _uid

foreign import _unrefTimer :: EffectFn1 Int Unit

unrefTimer :: Int -> Effect Unit
unrefTimer timerId = runEffectFn1 _unrefTimer timerId
