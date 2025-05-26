module Deno.FileSystem
  ( SymlinkType(..)
  , DirEntry
  , chmod
  , chown
  , copyFile
  , create
  , dirEntryIsDirectory
  , dirEntryIsFile
  , dirEntryIsSymlink
  , dirEntryName
  , link
  , lstat
  , makeTempDir
  , makeTempDirSync
  , makeTempFile
  , makeTempFileSync
  , mkdir
  , open
  , readDir
  , readFile
  , readLink
  , readTextFile
  , realPath
  , remove
  , rename
  , stat
  , symlink
  , truncate
  , umask
  , writeFile
  , writeTextFile
  ) where

import Prelude

import Data.ArrayBuffer.Types (Uint8Array)
import Data.Either (Either(..))
import Data.IsStringOrUrl (class IsStringOrUrl, StringOrUrl, toStringOrUrl)
import Data.Maybe (Maybe)
import Data.Nullable (Nullable, toNullable)
import Deno.FileSystem.FileInfo (FileInfo)
import Deno.FileSystem.FsFile (FsFile)
import Deno.FileSystem.MakeTempOptions (MakeTempOptions)
import Deno.FileSystem.MkdirOptions (MkdirOptions)
import Deno.FileSystem.OpenOptions (OpenOptions)
import Deno.FileSystem.WriteFileOptions (WriteFileOptions)
import Effect (Effect)
import Effect.Aff (Aff, Error, makeAff)
import Effect.Uncurried (EffectFn1, EffectFn2, EffectFn3, EffectFn4, EffectFn5, mkEffectFn1, runEffectFn1, runEffectFn2, runEffectFn3, runEffectFn4, runEffectFn5)

foreign import _chmod :: EffectFn4 StringOrUrl Int (Effect Unit) (EffectFn1 Error Unit) Unit

chmod :: forall a. IsStringOrUrl a => Int -> a -> Aff Unit
chmod mode path = makeAff \cb ->
  let
    onSuccess = cb (Right unit)
    onFailure = cb <<< Left
  in
    runEffectFn4 _chmod (toStringOrUrl path) mode onSuccess (mkEffectFn1 onFailure) *> mempty

foreign import _chown :: EffectFn5 StringOrUrl (Nullable Int) (Nullable Int) (Effect Unit) (EffectFn1 Error Unit) Unit

chown :: forall a. IsStringOrUrl a => Maybe Int -> Maybe Int -> a -> Aff Unit
chown uid' gid' path = makeAff \cb ->
  let
    onSuccess = cb (Right unit)
    onFailure = cb <<< Left
  in
    runEffectFn5 _chown (toStringOrUrl path) (toNullable uid') (toNullable gid') onSuccess (mkEffectFn1 onFailure) *> mempty

foreign import _copyFile :: EffectFn4 StringOrUrl StringOrUrl (Effect Unit) (EffectFn1 Error Unit) Unit

copyFile :: forall a b. IsStringOrUrl a => IsStringOrUrl b => a -> b -> Aff Unit
copyFile from to = makeAff \cb ->
  let
    onSuccess = cb (Right unit)
    onFailure = cb <<< Left
  in
    runEffectFn4 _copyFile (toStringOrUrl from) (toStringOrUrl to) onSuccess (mkEffectFn1 onFailure) *> mempty

foreign import _create :: EffectFn3 StringOrUrl (EffectFn1 FsFile Unit) (EffectFn1 Error Unit) Unit

create :: forall a. IsStringOrUrl a => a -> Aff FsFile
create path = makeAff \cb ->
  let
    onSuccess = cb <<< Right
    onFailure = cb <<< Left
  in
    runEffectFn3 _create (toStringOrUrl path) (mkEffectFn1 onSuccess) (mkEffectFn1 onFailure) *> mempty

foreign import _link :: EffectFn4 String String (Effect Unit) (EffectFn1 Error Unit) Unit

link :: String -> String -> Aff Unit
link oldPath newPath = makeAff \cb ->
  let
    onSuccess = cb (Right unit)
    onFailure = cb <<< Left
  in
    runEffectFn4 _link oldPath newPath onSuccess (mkEffectFn1 onFailure) *> mempty

foreign import _mkdir :: EffectFn4 MkdirOptions StringOrUrl (Effect Unit) (EffectFn1 Error Unit) Unit

mkdir :: forall a. IsStringOrUrl a => MkdirOptions -> a -> Aff Unit
mkdir opts path = makeAff \cb ->
  let
    onSuccess = cb (Right unit)
    onFailure = cb <<< Left
  in
    runEffectFn4 _mkdir opts (toStringOrUrl path) onSuccess (mkEffectFn1 onFailure) *> mempty

foreign import _open :: EffectFn4 OpenOptions StringOrUrl (EffectFn1 FsFile Unit) (EffectFn1 Error Unit) Unit

open :: forall a. IsStringOrUrl a => OpenOptions -> a -> Aff FsFile
open opts path = makeAff \cb ->
  let
    onSuccess = cb <<< Right
    onFailure = cb <<< Left
  in
    runEffectFn4 _open opts (toStringOrUrl path) (mkEffectFn1 onSuccess) (mkEffectFn1 onFailure) *> mempty

foreign import _readFile :: EffectFn3 StringOrUrl (EffectFn1 Uint8Array Unit) (EffectFn1 Error Unit) Unit

readFile :: forall a. IsStringOrUrl a => a -> Aff Uint8Array
readFile path = makeAff \cb ->
  let
    onSuccess = cb <<< Right
    onFailure = cb <<< Left
  in
    runEffectFn3 _readFile (toStringOrUrl path) (mkEffectFn1 onSuccess) (mkEffectFn1 onFailure) *> mempty

foreign import _readTextFile :: EffectFn3 StringOrUrl (EffectFn1 String Unit) (EffectFn1 Error Unit) Unit

readTextFile :: forall a. IsStringOrUrl a => a -> Aff String
readTextFile path = makeAff \cb ->
  let
    onSuccess = cb <<< Right
    onFailure = cb <<< Left
  in
    runEffectFn3 _readTextFile (toStringOrUrl path) (mkEffectFn1 onSuccess) (mkEffectFn1 onFailure) *> mempty

foreign import _remove :: EffectFn4 StringOrUrl Boolean (Effect Unit) (EffectFn1 Error Unit) Unit

remove :: forall a. IsStringOrUrl a => Boolean -> a -> Aff Unit
remove recursive path = makeAff \cb ->
  let
    onSuccess = cb (Right unit)
    onFailure = cb <<< Left
  in
    runEffectFn4 _remove (toStringOrUrl path) recursive onSuccess (mkEffectFn1 onFailure) *> mempty

foreign import _rename :: EffectFn4 StringOrUrl StringOrUrl (Effect Unit) (EffectFn1 Error Unit) Unit

rename :: forall a b. IsStringOrUrl a => IsStringOrUrl b => a -> b -> Aff Unit
rename oldPath newPath = makeAff \cb ->
  let
    onSuccess = cb (Right unit)
    onFailure = cb <<< Left
  in
    runEffectFn4 _rename (toStringOrUrl oldPath) (toStringOrUrl newPath) onSuccess (mkEffectFn1 onFailure) *> mempty

data SymlinkType = File | Dir | Junction

symlinkTypeToString :: SymlinkType -> String
symlinkTypeToString = case _ of
  File -> "file"
  Dir -> "dir"
  Junction -> "junction"

foreign import _symlink :: EffectFn5 StringOrUrl StringOrUrl (Nullable String) (Effect Unit) (EffectFn1 Error Unit) Unit

symlink :: forall a b. IsStringOrUrl a => IsStringOrUrl b => Maybe SymlinkType -> a -> b -> Aff Unit
symlink symlinkType oldPath newPath = makeAff \cb ->
  let
    onSuccess = cb (Right unit)
    onFailure = cb <<< Left
    symlinkType' = toNullable $ symlinkTypeToString <$> symlinkType
  in
    runEffectFn5 _symlink (toStringOrUrl oldPath) (toStringOrUrl newPath) symlinkType' onSuccess (mkEffectFn1 onFailure) *> mempty

foreign import _truncate :: EffectFn4 FsFile (Nullable Int) (Effect Unit) (EffectFn1 Error Unit) Unit

truncate :: Maybe Int -> FsFile -> Aff Unit
truncate size file = makeAff \cb ->
  let
    onSuccess = cb (Right unit)
    onFailure = cb <<< Left
    size' = toNullable size
  in
    runEffectFn4 _truncate file size' onSuccess (mkEffectFn1 onFailure) *> mempty

foreign import _umask :: EffectFn1 (Nullable Int) Int

umask :: Maybe Int -> Effect Int
umask mask = runEffectFn1 _umask (toNullable mask)

foreign import _writeFile :: EffectFn5 WriteFileOptions StringOrUrl Uint8Array (Effect Unit) (EffectFn1 Error Unit) Unit

writeFile :: forall a. IsStringOrUrl a => WriteFileOptions -> a -> Uint8Array -> Aff Unit
writeFile opts path content = makeAff \cb ->
  let
    onSuccess = cb (Right unit)
    onFailure = cb <<< Left
  in
    runEffectFn5 _writeFile opts (toStringOrUrl path) content onSuccess (mkEffectFn1 onFailure) *> mempty

foreign import _writeTextFile :: EffectFn5 WriteFileOptions String String (Effect Unit) (EffectFn1 Error Unit) Unit

writeTextFile :: WriteFileOptions -> String -> String -> Aff Unit
writeTextFile opts path content = makeAff \cb ->
  let
    onSuccess = cb (Right unit)
    onFailure = cb <<< Left
  in
    runEffectFn5 _writeTextFile opts path content onSuccess (mkEffectFn1 onFailure) *> mempty

-- Additional file system operations

-- Directory reading with simple DirEntry representation
foreign import data DirEntry :: Type

foreign import _readDir :: EffectFn3 StringOrUrl (EffectFn1 (Array DirEntry) Unit) (EffectFn1 Error Unit) Unit

readDir :: forall a. IsStringOrUrl a => a -> Aff (Array DirEntry)
readDir path = makeAff \cb ->
  let
    onSuccess = cb <<< Right
    onFailure = cb <<< Left
  in
    runEffectFn3 _readDir (toStringOrUrl path) (mkEffectFn1 onSuccess) (mkEffectFn1 onFailure) *> mempty

foreign import _stat :: EffectFn3 StringOrUrl (EffectFn1 FileInfo Unit) (EffectFn1 Error Unit) Unit

stat :: forall a. IsStringOrUrl a => a -> Aff FileInfo
stat path = makeAff \cb ->
  let
    onSuccess = cb <<< Right
    onFailure = cb <<< Left
  in
    runEffectFn3 _stat (toStringOrUrl path) (mkEffectFn1 onSuccess) (mkEffectFn1 onFailure) *> mempty

foreign import _lstat :: EffectFn3 StringOrUrl (EffectFn1 FileInfo Unit) (EffectFn1 Error Unit) Unit

lstat :: forall a. IsStringOrUrl a => a -> Aff FileInfo
lstat path = makeAff \cb ->
  let
    onSuccess = cb <<< Right
    onFailure = cb <<< Left
  in
    runEffectFn3 _lstat (toStringOrUrl path) (mkEffectFn1 onSuccess) (mkEffectFn1 onFailure) *> mempty

foreign import _realPath :: EffectFn3 StringOrUrl (EffectFn1 String Unit) (EffectFn1 Error Unit) Unit

realPath :: forall a. IsStringOrUrl a => a -> Aff String
realPath path = makeAff \cb ->
  let
    onSuccess = cb <<< Right
    onFailure = cb <<< Left
  in
    runEffectFn3 _realPath (toStringOrUrl path) (mkEffectFn1 onSuccess) (mkEffectFn1 onFailure) *> mempty

foreign import _readLink :: EffectFn3 StringOrUrl (EffectFn1 String Unit) (EffectFn1 Error Unit) Unit

readLink :: forall a. IsStringOrUrl a => a -> Aff String
readLink path = makeAff \cb ->
  let
    onSuccess = cb <<< Right
    onFailure = cb <<< Left
  in
    runEffectFn3 _readLink (toStringOrUrl path) (mkEffectFn1 onSuccess) (mkEffectFn1 onFailure) *> mempty

-- DirEntry accessor functions
foreign import _dirEntryName :: EffectFn1 DirEntry String
foreign import _dirEntryIsFile :: EffectFn1 DirEntry Boolean
foreign import _dirEntryIsDirectory :: EffectFn1 DirEntry Boolean
foreign import _dirEntryIsSymlink :: EffectFn1 DirEntry Boolean

dirEntryName :: DirEntry -> Effect String
dirEntryName = runEffectFn1 _dirEntryName

dirEntryIsFile :: DirEntry -> Effect Boolean
dirEntryIsFile = runEffectFn1 _dirEntryIsFile

dirEntryIsDirectory :: DirEntry -> Effect Boolean
dirEntryIsDirectory = runEffectFn1 _dirEntryIsDirectory

dirEntryIsSymlink :: DirEntry -> Effect Boolean
dirEntryIsSymlink = runEffectFn1 _dirEntryIsSymlink

-- Temporary directory and file creation functions

foreign import _makeTempDir :: EffectFn3 MakeTempOptions (EffectFn1 String Unit) (EffectFn1 Error Unit) Unit

makeTempDir :: MakeTempOptions -> Aff String
makeTempDir opts = makeAff \cb ->
  let
    onSuccess = cb <<< Right
    onFailure = cb <<< Left
  in
    runEffectFn3 _makeTempDir opts (mkEffectFn1 onSuccess) (mkEffectFn1 onFailure) *> mempty

foreign import _makeTempDirSync :: EffectFn1 MakeTempOptions String

makeTempDirSync :: MakeTempOptions -> Effect String
makeTempDirSync = runEffectFn1 _makeTempDirSync

foreign import _makeTempFile :: EffectFn3 MakeTempOptions (EffectFn1 String Unit) (EffectFn1 Error Unit) Unit

makeTempFile :: MakeTempOptions -> Aff String
makeTempFile opts = makeAff \cb ->
  let
    onSuccess = cb <<< Right
    onFailure = cb <<< Left
  in
    runEffectFn3 _makeTempFile opts (mkEffectFn1 onSuccess) (mkEffectFn1 onFailure) *> mempty

foreign import _makeTempFileSync :: EffectFn1 MakeTempOptions String

makeTempFileSync :: MakeTempOptions -> Effect String
makeTempFileSync = runEffectFn1 _makeTempFileSync
