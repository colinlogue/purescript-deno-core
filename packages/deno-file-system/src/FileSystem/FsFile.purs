module Deno.FileSystem.FsFile
  ( FsFile
  , SetRawOptions
  , SeekMode
  , readable
  , writable
  , close
  , isTerminal
  , lock
  , lockSync
  , read
  , readSync
  , seek
  , seekSync
  , seekStart
  , seekCurrent
  , seekEnd
  , setRaw
  , stat
  , statSync
  , sync
  , syncData
  , syncDataSync
  , syncSync
  , truncate
  , truncateSync
  , unlock
  , unlockSync
  , utime
  , utimeSync
  , write
  , writeSync
  ) where

import Prelude

import Data.ArrayBuffer.Types (Uint8Array)
-- Remove unused import
-- import Data.Either (Either(..))
import Data.Maybe (Maybe)
import Data.Nullable (Nullable, toNullable, toMaybe)
import Deno.FileSystem.FileInfo (FileInfo)
import Deno.Util (runAsyncEffect1, runAsyncEffect2, runAsyncEffect3)
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Exception (Error)
import Effect.Uncurried (EffectFn1, EffectFn2, EffectFn3, EffectFn4, EffectFn5, runEffectFn1, runEffectFn2, runEffectFn3)
import Web.Streams.ReadableStream (ReadableStream)
import Web.Streams.WritableStream (WritableStream)


foreign import data FsFile :: Type

type SetRawOptions = { cbreak :: Boolean }

-- Properties

foreign import _readable :: EffectFn1 FsFile (ReadableStream Uint8Array)

readable :: FsFile -> Effect (ReadableStream Uint8Array)
readable = runEffectFn1 _readable

foreign import _writable :: EffectFn1 FsFile (WritableStream Uint8Array)

writable :: FsFile -> Effect (WritableStream Uint8Array)
writable = runEffectFn1 _writable

-- Methods

foreign import _close :: EffectFn1 FsFile Unit

close :: FsFile -> Effect Unit
close = runEffectFn1 _close

foreign import _isTerminal :: EffectFn1 FsFile Boolean

isTerminal :: FsFile -> Effect Boolean
isTerminal = runEffectFn1 _isTerminal

foreign import _lock :: EffectFn4 FsFile Boolean (EffectFn1 Unit Unit) (EffectFn1 Error Unit) Unit

lock :: Boolean -> FsFile -> Aff Unit
lock blocking file = runAsyncEffect2 _lock file blocking

foreign import _lockSync :: EffectFn2 FsFile Boolean Unit

lockSync :: Boolean -> FsFile -> Effect Unit
lockSync blocking file = runEffectFn2 _lockSync file blocking

foreign import _read :: EffectFn4 Uint8Array FsFile (EffectFn1 (Nullable Int) Unit) (EffectFn1 Error Unit) Unit

read :: Uint8Array -> FsFile -> Aff (Maybe Int)
read buffer file = toMaybe <$> runAsyncEffect2 _read buffer file

foreign import _readSync :: EffectFn2 Uint8Array FsFile (Nullable Int)

readSync :: Uint8Array -> FsFile -> Effect (Maybe Int)
readSync buffer file = toMaybe <$> runEffectFn2 _readSync buffer file

foreign import _seek :: EffectFn5 Int SeekMode FsFile (EffectFn1 Unit Unit) (EffectFn1 Error Unit) Unit

foreign import data SeekMode :: Type

foreign import seekStart :: SeekMode

foreign import seekCurrent :: SeekMode

foreign import seekEnd :: SeekMode

seek :: Int -> SeekMode -> FsFile -> Aff Unit
seek offset mode file = runAsyncEffect3 _seek offset mode file

foreign import _seekSync :: EffectFn3 Int SeekMode FsFile Int

seekSync :: Int -> SeekMode -> FsFile -> Effect Int
seekSync offset mode file = runEffectFn3 _seekSync offset mode file

foreign import _setRaw :: EffectFn3 Boolean (Nullable SetRawOptions) FsFile Unit

setRaw :: Boolean -> Maybe SetRawOptions -> FsFile -> Effect Unit
setRaw mode opts file = runEffectFn3 _setRaw mode (toNullable opts) file

foreign import _stat :: EffectFn3 FsFile (EffectFn1 FileInfo Unit) (EffectFn1 Error Unit) Unit

stat :: FsFile -> Aff FileInfo
stat file = runAsyncEffect1 _stat file

foreign import _statSync :: EffectFn1 FsFile FileInfo

statSync :: FsFile -> Effect FileInfo
statSync = runEffectFn1 _statSync

foreign import _syncData :: EffectFn3 FsFile (EffectFn1 Unit Unit) (EffectFn1 Error Unit) Unit

syncData :: FsFile -> Aff Unit
syncData file = runAsyncEffect1 _syncData file

foreign import _syncDataSync :: EffectFn1 FsFile Unit

syncDataSync :: FsFile -> Effect Unit
syncDataSync = runEffectFn1 _syncDataSync

foreign import _syncSync :: EffectFn1 FsFile Unit

syncSync :: FsFile -> Effect Unit
syncSync = runEffectFn1 _syncSync

foreign import _truncateSync :: EffectFn2 (Nullable Int) FsFile Unit

truncateSync :: Maybe Int -> FsFile -> Effect Unit
truncateSync size file = runEffectFn2 _truncateSync (toNullable size) file

foreign import _utime :: EffectFn5 Number Number FsFile (EffectFn1 Unit Unit) (EffectFn1 Error Unit) Unit

utime :: Number -> Number -> FsFile -> Aff Unit
utime atime mtime file = runAsyncEffect3 _utime atime mtime file

foreign import _utimeSync :: EffectFn3 Number Number FsFile Unit

utimeSync :: Number -> Number -> FsFile -> Effect Unit
utimeSync atime mtime file = runEffectFn3 _utimeSync atime mtime file

foreign import _write :: EffectFn4 Uint8Array FsFile (EffectFn1 Int Unit) (EffectFn1 Error Unit) Unit

write :: Uint8Array -> FsFile -> Aff Int
write buffer file = runAsyncEffect2 _write buffer file

foreign import _writeSync :: EffectFn2 Uint8Array FsFile Int

writeSync :: Uint8Array -> FsFile -> Effect Int
writeSync buffer file = runEffectFn2 _writeSync buffer file

foreign import _truncate :: EffectFn4 (Nullable Int) FsFile (EffectFn1 Unit Unit) (EffectFn1 Error Unit) Unit

foreign import _sync :: EffectFn3 FsFile (EffectFn1 Unit Unit) (EffectFn1 Error Unit) Unit

sync :: FsFile -> Aff Unit
sync file = runAsyncEffect1 _sync file

truncate :: Maybe Int -> FsFile -> Aff Unit
truncate size file = runAsyncEffect2 _truncate (toNullable size) file

foreign import _unlock :: EffectFn3 FsFile (EffectFn1 Unit Unit) (EffectFn1 Error Unit) Unit

unlock :: FsFile -> Aff Unit
unlock file = runAsyncEffect1 _unlock file

foreign import _unlockSync :: EffectFn1 FsFile Unit

unlockSync :: FsFile -> Effect Unit
unlockSync = runEffectFn1 _unlockSync
