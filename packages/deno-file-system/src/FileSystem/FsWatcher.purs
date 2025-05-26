module Deno.FileSystem.FsWatcher where

import Prelude

import Data.Maybe (Maybe)
import Data.Nullable (Nullable)
import Data.Nullable as Nullable
import Effect (Effect)
import Effect.Uncurried (EffectFn1, runEffectFn1)


foreign import data FsWatcher :: Type
foreign import data FsEvent :: Type

data FsEventKind = Any | Access | Create | Modify | Remove | Other

data FsEventFlag = Rescan | Unknown

foreign import _fsWatcherClose :: EffectFn1 FsWatcher Unit

fsWatcherClose :: FsWatcher -> Effect Unit
fsWatcherClose = runEffectFn1 _fsWatcherClose

-- FsEvent accessor functions
foreign import _fsEventKind :: EffectFn1 FsEvent String
foreign import _fsEventFlag :: EffectFn1 FsEvent (Nullable String)
foreign import _fsEventPaths :: EffectFn1 FsEvent (Array String)

fsEventKind :: FsEvent -> Effect String
fsEventKind = runEffectFn1 _fsEventKind

fsEventFlag :: FsEvent -> Effect (Maybe String)
fsEventFlag event = Nullable.toMaybe <$> runEffectFn1 _fsEventFlag event

fsEventPaths :: FsEvent -> Effect (Array String)
fsEventPaths = runEffectFn1 _fsEventPaths
