module Deno.Runtime
  ( chdir
  , cwd
  , execPath
  , exit
  , gid
  , hostname
  , loadavg
  , LoadAvgResult(..)
  , memoryUsage
  , osRelease
  , osUptime
  , refTimer
  , systemMemoryInfo
  , SystemMemoryInfoResult
  , uid
  , unrefTimer
  , addSignalListener
  , removeSignalListener
  -- Variables
  , args
  , build
  , BuildInfo
  , env
  , exitCode
  , setExitCode
  , mainModule
  , noColor
  , pid
  , ppid
  , version
  , VersionInfo
  ) where

import Prelude

import Data.IsStringOrUrl (class IsStringOrUrl, StringOrUrl, toStringOrUrl)
import Data.Maybe (Maybe)
import Data.Nullable (Nullable)
import Data.Nullable as Nullable
import Deno.Runtime.Env (Env)
import Deno.Runtime.Signal (Signal)
import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn2, runEffectFn1, runEffectFn2)

data LoadAvgResult = LoadAvgResult Number Number Number

derive instance Eq LoadAvgResult
derive instance Ord LoadAvgResult

instance Show LoadAvgResult where
  show (LoadAvgResult min1 min5 min15) =
    "LoadAvgResult " <> show min1 <> " " <> show min5 <> " " <> show min15

type MemoryUsageResult =
  { rss :: Number
  , heapTotal :: Number
  , heapUsed :: Number
  , external :: Number
  }

type SystemMemoryInfoResult =
  { total :: Number
  , free :: Number
  , available :: Number
  , buffers :: Number
  , cached :: Number
  , swapTotal :: Number
  , swapFree :: Number
  }

type BuildInfo =
  { target :: String
  , arch :: String
  , os :: String
  , vendor :: String
  , env :: Maybe String
  , standalone :: Boolean
  }

type VersionInfo =
  { deno :: String
  , v8 :: String
  , typescript :: String
  }

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

foreign import _loadavg :: EffectFn1 (Number -> Number -> Number -> LoadAvgResult) LoadAvgResult

loadavg :: Effect LoadAvgResult
loadavg = runEffectFn1 _loadavg LoadAvgResult

foreign import _memoryUsage :: Effect MemoryUsageResult

memoryUsage :: Effect MemoryUsageResult
memoryUsage = _memoryUsage

foreign import osRelease :: Effect String

foreign import osUptime :: Effect Number

foreign import _systemMemoryInfo :: Effect SystemMemoryInfoResult

systemMemoryInfo :: Effect SystemMemoryInfoResult
systemMemoryInfo = _systemMemoryInfo

foreign import _uid :: Effect (Nullable Int)

uid :: Effect (Maybe Int)
uid = Nullable.toMaybe <$> _uid

foreign import _refTimer :: EffectFn1 Int Unit

refTimer :: Int -> Effect Unit
refTimer timerId = runEffectFn1 _refTimer timerId

foreign import _unrefTimer :: EffectFn1 Int Unit

unrefTimer :: Int -> Effect Unit
unrefTimer timerId = runEffectFn1 _unrefTimer timerId

foreign import _addSignalListener :: EffectFn2 String (Effect Unit) Unit

addSignalListener :: Signal -> Effect Unit -> Effect Unit
addSignalListener signal handler = runEffectFn2 _addSignalListener (show signal) handler

foreign import _removeSignalListener :: EffectFn2 String (Effect Unit) Unit

removeSignalListener :: Signal -> Effect Unit -> Effect Unit
removeSignalListener signal handler = runEffectFn2 _removeSignalListener (show signal) handler

-- Variables
foreign import args :: Array String

foreign import build :: BuildInfo

foreign import env :: Env

foreign import _getExitCode :: Effect Int
foreign import _setExitCode :: EffectFn1 Int Unit

exitCode :: Effect Int
exitCode = _getExitCode

setExitCode :: Int -> Effect Unit
setExitCode code = runEffectFn1 _setExitCode code

foreign import mainModule :: String

foreign import noColor :: Boolean

foreign import pid :: Int

foreign import ppid :: Int

foreign import version :: VersionInfo
