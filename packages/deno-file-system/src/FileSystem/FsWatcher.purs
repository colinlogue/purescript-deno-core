module Deno.FileSystem.FsWatcher where

import Prelude

import Data.Maybe (Maybe)
import Data.Nullable (Nullable)
import Data.Nullable as Nullable
import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn2, runEffectFn1, runEffectFn2)


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

-- Watch for FsEvents
foreign import _watch :: EffectFn2 (FsEvent -> Effect Unit) FsWatcher (Effect Unit)

-- | Watch for filesystem events emitted by a FsWatcher.
-- |
-- | This function takes a callback that will be invoked for each event emitted
-- | and returns an Effect that, when executed, will stop watching for events.
-- |
-- | ```purescript
-- | do
-- |   watcher <- watchFs ["/path/to/watch"] false
-- |   stopWatching <- watch (\event -> do
-- |     paths <- fsEventPaths event
-- |     log $ "File change detected: " <> show paths
-- |   ) watcher
-- |   
-- |   -- Later, to stop watching:
-- |   stopWatching
-- | ```
watch :: (FsEvent -> Effect Unit) -> FsWatcher -> Effect (Effect Unit)
watch handler watcher = runEffectFn2 _watch handler watcher
