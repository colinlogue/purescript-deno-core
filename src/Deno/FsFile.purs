module Deno.FsFile
  ( FsFile
  , readable
  , writable
  , close
  , isTerminal
  , lock
  , lockSync
  , read
  , seek
  , SeekMode
  , seekStart
  , seekCurrent
  , seekEnd
  , sync
  , truncate
  , unlock
  , unlockSync
  ) where

import Prelude

import Data.ArrayBuffer.Types (Uint8Array)
import Data.Either (Either(..))
import Data.Maybe (Maybe)
import Data.Nullable (Nullable, toNullable, toMaybe)
import Effect (Effect)
import Effect.Aff (Aff, makeAff)
import Effect.Exception (Error)
import Effect.Uncurried (EffectFn1, EffectFn2, EffectFn3, EffectFn4, EffectFn5, mkEffectFn1, runEffectFn1, runEffectFn2, runEffectFn3, runEffectFn4, runEffectFn5)
import Web.Streams.ReadableStream (ReadableStream)
import Web.Streams.WritableStream (WritableStream)


foreign import data FsFile :: Type

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

foreign import _lock :: EffectFn4 FsFile Boolean (Effect Unit) (EffectFn1 Error Unit) Unit

lock :: Boolean -> FsFile -> Aff Unit
lock blocking file = makeAff \cb ->
  let
    onSuccess = cb (Right unit)
    onFailure = cb <<< Left
  in
    runEffectFn4 _lock file blocking onSuccess (mkEffectFn1 onFailure) *> mempty

foreign import _lockSync :: EffectFn2 FsFile Boolean Unit

lockSync :: Boolean -> FsFile -> Effect Unit
lockSync blocking file = runEffectFn2 _lockSync file blocking

foreign import _read :: EffectFn4 Uint8Array FsFile (EffectFn1 (Nullable Int) Unit) (EffectFn1 Error Unit) Unit

read :: Uint8Array -> FsFile -> Aff (Maybe Int)
read buffer file = makeAff \cb ->
  let
    onSuccess = cb <<< Right <<< toMaybe
    onFailure = cb <<< Left
  in
    runEffectFn4 _read buffer file (mkEffectFn1 onSuccess) (mkEffectFn1 onFailure) *> mempty

foreign import _seek :: EffectFn5 Int SeekMode FsFile (Effect Unit) (EffectFn1 Error Unit) Unit

foreign import data SeekMode :: Type

foreign import seekStart :: SeekMode

foreign import seekCurrent :: SeekMode

foreign import seekEnd :: SeekMode

seek :: Int -> SeekMode -> FsFile -> Aff Unit
seek offset mode file = makeAff \cb ->
  let
    onSuccess = cb (Right unit)
    onFailure = cb <<< Left
  in
    runEffectFn5 _seek offset mode file onSuccess (mkEffectFn1 onFailure) *> mempty

foreign import _truncate :: EffectFn4 (Nullable Int) FsFile (Effect Unit) (EffectFn1 Error Unit) Unit

foreign import _sync :: EffectFn3 FsFile (Effect Unit) (EffectFn1 Error Unit) Unit

sync :: FsFile -> Aff Unit
sync file = makeAff \cb ->
  let
    onSuccess = cb (Right unit)
    onFailure = cb <<< Left
  in
    runEffectFn3 _sync file onSuccess (mkEffectFn1 onFailure) *> mempty

truncate :: Maybe Int -> FsFile -> Aff Unit
truncate size file = makeAff \cb ->
  let
    onSuccess = cb (Right unit)
    onFailure = cb <<< Left
  in
    runEffectFn4 _truncate (toNullable size) file onSuccess (mkEffectFn1 onFailure) *> mempty

foreign import _unlock :: EffectFn3 FsFile (Effect Unit) (EffectFn1 Error Unit) Unit

unlock :: FsFile -> Aff Unit
unlock file = makeAff \cb ->
  let
    onSuccess = cb (Right unit)
    onFailure = cb <<< Left
  in
    runEffectFn3 _unlock file onSuccess (mkEffectFn1 onFailure) *> mempty

foreign import _unlockSync :: EffectFn1 FsFile Unit

unlockSync :: FsFile -> Effect Unit
unlockSync = runEffectFn1 _unlockSync
