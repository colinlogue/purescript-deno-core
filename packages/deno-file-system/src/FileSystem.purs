module Deno.FileSystem
  ( SymlinkType(..)
  , DirEntry
  , chmod
  , chmodSync
  , chown
  , chownSync
  , copyFile
  , copyFileSync
  , create
  , createSync
  , dirEntryIsDirectory
  , dirEntryIsFile
  , dirEntryIsSymlink
  , dirEntryName
  , link
  , linkSync
  , lstat
  , lstatSync
  , makeTempDir
  , makeTempDirSync
  , makeTempFile
  , makeTempFileSync
  , mkdir
  , mkdirSync
  , open
  , openSync
  , readDir
  , readFile
  , readFileSync
  , readLink
  , readLinkSync
  , readTextFile
  , readTextFileSync
  , realPath
  , realPathSync
  , remove
  , removeSync
  , rename
  , renameSync
  , stat
  , statSync
  , symlink
  , truncate
  , umask
  , utime
  , utimeSync
  , watchFs
  , writeFile
  , writeFileSync
  , writeTextFile
  , writeTextFileSync
  ) where

import Prelude

import Data.ArrayBuffer.Types (Uint8Array)
-- Remove unused import
-- import Data.Either (Either(..))
import Data.IsStringOrUrl (class IsStringOrUrl, StringOrUrl, toStringOrUrl)
import Data.Maybe (Maybe)
import Data.Nullable (Nullable, toNullable)
import Deno.FileSystem.FileInfo (FileInfo)
import Deno.FileSystem.FsFile (FsFile)
import Deno.FileSystem.FsWatcher (FsWatcher)
import Deno.FileSystem.MakeTempOptions (MakeTempOptions)
import Deno.FileSystem.MkdirOptions (MkdirOptions)
import Deno.FileSystem.OpenOptions (OpenOptions)
import Deno.FileSystem.WriteFileOptions (WriteFileOptions)
import Deno.Util (runAsyncEffect1, runAsyncEffect2, runAsyncEffect3)
import Effect (Effect)
import Effect.Aff (Aff, Error)
import Effect.Uncurried (EffectFn1, EffectFn2, EffectFn3, EffectFn4, EffectFn5, runEffectFn1, runEffectFn2, runEffectFn3)

-- Async foreign imports
foreign import _chmod :: EffectFn4 StringOrUrl Int (EffectFn1 Unit Unit) (EffectFn1 Error Unit) Unit
foreign import _chown :: EffectFn5 StringOrUrl (Nullable Int) (Nullable Int) (EffectFn1 Unit Unit) (EffectFn1 Error Unit) Unit
foreign import _copyFile :: EffectFn4 StringOrUrl StringOrUrl (EffectFn1 Unit Unit) (EffectFn1 Error Unit) Unit
foreign import _create :: EffectFn3 StringOrUrl (EffectFn1 FsFile Unit) (EffectFn1 Error Unit) Unit
foreign import _link :: EffectFn4 String String (EffectFn1 Unit Unit) (EffectFn1 Error Unit) Unit
foreign import _mkdir :: EffectFn4 MkdirOptions StringOrUrl (EffectFn1 Unit Unit) (EffectFn1 Error Unit) Unit
foreign import _open :: EffectFn4 OpenOptions StringOrUrl (EffectFn1 FsFile Unit) (EffectFn1 Error Unit) Unit
foreign import _readFile :: EffectFn3 StringOrUrl (EffectFn1 Uint8Array Unit) (EffectFn1 Error Unit) Unit
foreign import _readTextFile :: EffectFn3 StringOrUrl (EffectFn1 String Unit) (EffectFn1 Error Unit) Unit
foreign import _remove :: EffectFn4 StringOrUrl Boolean (EffectFn1 Unit Unit) (EffectFn1 Error Unit) Unit
foreign import _rename :: EffectFn4 StringOrUrl StringOrUrl (EffectFn1 Unit Unit) (EffectFn1 Error Unit) Unit
foreign import _symlink :: EffectFn5 StringOrUrl StringOrUrl (Nullable String) (EffectFn1 Unit Unit) (EffectFn1 Error Unit) Unit
foreign import _truncate :: EffectFn4 FsFile (Nullable Int) (EffectFn1 Unit Unit) (EffectFn1 Error Unit) Unit
foreign import _umask :: EffectFn1 (Nullable Int) Int
foreign import _writeFile :: EffectFn5 WriteFileOptions StringOrUrl Uint8Array (EffectFn1 Unit Unit) (EffectFn1 Error Unit) Unit
foreign import _writeTextFile :: EffectFn5 WriteFileOptions StringOrUrl String (EffectFn1 Unit Unit) (EffectFn1 Error Unit) Unit
foreign import _readDir :: EffectFn3 StringOrUrl (EffectFn1 (Array DirEntry) Unit) (EffectFn1 Error Unit) Unit
foreign import _stat :: EffectFn3 StringOrUrl (EffectFn1 FileInfo Unit) (EffectFn1 Error Unit) Unit
foreign import _lstat :: EffectFn3 StringOrUrl (EffectFn1 FileInfo Unit) (EffectFn1 Error Unit) Unit
foreign import _realPath :: EffectFn3 StringOrUrl (EffectFn1 String Unit) (EffectFn1 Error Unit) Unit
foreign import _readLink :: EffectFn3 StringOrUrl (EffectFn1 String Unit) (EffectFn1 Error Unit) Unit
foreign import _makeTempDir :: EffectFn3 MakeTempOptions (EffectFn1 String Unit) (EffectFn1 Error Unit) Unit
foreign import _makeTempFile :: EffectFn3 MakeTempOptions (EffectFn1 String Unit) (EffectFn1 Error Unit) Unit
foreign import _utime :: EffectFn5 StringOrUrl Number Number (EffectFn1 Unit Unit) (EffectFn1 Error Unit) Unit
foreign import _watchFs :: EffectFn2 (Array String) { recursive :: Boolean } FsWatcher

-- Sync foreign imports
foreign import _chmodSync :: EffectFn2 StringOrUrl Int Unit
foreign import _chownSync :: EffectFn3 StringOrUrl (Nullable Int) (Nullable Int) Unit
foreign import _copyFileSync :: EffectFn2 StringOrUrl StringOrUrl Unit
foreign import _createSync :: EffectFn1 StringOrUrl FsFile
foreign import _linkSync :: EffectFn2 String String Unit
foreign import _mkdirSync :: EffectFn2 MkdirOptions StringOrUrl Unit
foreign import _openSync :: EffectFn2 OpenOptions StringOrUrl FsFile
foreign import _readFileSync :: EffectFn1 StringOrUrl Uint8Array
foreign import _readTextFileSync :: EffectFn1 StringOrUrl String
foreign import _removeSync :: EffectFn2 StringOrUrl Boolean Unit
foreign import _renameSync :: EffectFn2 StringOrUrl StringOrUrl Unit
foreign import _statSync :: EffectFn1 StringOrUrl FileInfo
foreign import _lstatSync :: EffectFn1 StringOrUrl FileInfo
foreign import _realPathSync :: EffectFn1 StringOrUrl String
foreign import _readLinkSync :: EffectFn1 StringOrUrl String
foreign import _writeFileSync :: EffectFn3 WriteFileOptions StringOrUrl Uint8Array Unit
foreign import _writeTextFileSync :: EffectFn3 WriteFileOptions StringOrUrl String Unit
foreign import _makeTempDirSync :: EffectFn1 MakeTempOptions String
foreign import _makeTempFileSync :: EffectFn1 MakeTempOptions String
foreign import _utimeSync :: EffectFn3 StringOrUrl Number Number Unit

chmodSync :: forall a. IsStringOrUrl a => Int -> a -> Effect Unit
chmodSync mode path = runEffectFn2 _chmodSync (toStringOrUrl path) mode

chownSync :: forall a. IsStringOrUrl a => Maybe Int -> Maybe Int -> a -> Effect Unit
chownSync uid' gid' path = runEffectFn3 _chownSync (toStringOrUrl path) (toNullable uid') (toNullable gid')

copyFileSync :: forall a b. IsStringOrUrl a => IsStringOrUrl b => a -> b -> Effect Unit
copyFileSync from to = runEffectFn2 _copyFileSync (toStringOrUrl from) (toStringOrUrl to)

createSync :: forall a. IsStringOrUrl a => a -> Effect FsFile
createSync path = runEffectFn1 _createSync (toStringOrUrl path)

linkSync :: String -> String -> Effect Unit
linkSync oldPath newPath = runEffectFn2 _linkSync oldPath newPath

mkdirSync :: forall a. IsStringOrUrl a => MkdirOptions -> a -> Effect Unit
mkdirSync opts path = runEffectFn2 _mkdirSync opts (toStringOrUrl path)

openSync :: forall a. IsStringOrUrl a => OpenOptions -> a -> Effect FsFile
openSync opts path = runEffectFn2 _openSync opts (toStringOrUrl path)

readFileSync :: forall a. IsStringOrUrl a => a -> Effect Uint8Array
readFileSync path = runEffectFn1 _readFileSync (toStringOrUrl path)

readTextFileSync :: forall a. IsStringOrUrl a => a -> Effect String
readTextFileSync path = runEffectFn1 _readTextFileSync (toStringOrUrl path)

removeSync :: forall a. IsStringOrUrl a => Boolean -> a -> Effect Unit
removeSync recursive path = runEffectFn2 _removeSync (toStringOrUrl path) recursive

renameSync :: forall a b. IsStringOrUrl a => IsStringOrUrl b => a -> b -> Effect Unit
renameSync oldPath newPath = runEffectFn2 _renameSync (toStringOrUrl oldPath) (toStringOrUrl newPath)

statSync :: forall a. IsStringOrUrl a => a -> Effect FileInfo
statSync path = runEffectFn1 _statSync (toStringOrUrl path)

lstatSync :: forall a. IsStringOrUrl a => a -> Effect FileInfo
lstatSync path = runEffectFn1 _lstatSync (toStringOrUrl path)

realPathSync :: forall a. IsStringOrUrl a => a -> Effect String
realPathSync path = runEffectFn1 _realPathSync (toStringOrUrl path)

readLinkSync :: forall a. IsStringOrUrl a => a -> Effect String
readLinkSync path = runEffectFn1 _readLinkSync (toStringOrUrl path)

writeFileSync :: forall a. IsStringOrUrl a => WriteFileOptions -> a -> Uint8Array -> Effect Unit
writeFileSync opts path content = runEffectFn3 _writeFileSync opts (toStringOrUrl path) content

writeTextFileSync :: forall a. IsStringOrUrl a => WriteFileOptions -> a -> String -> Effect Unit
writeTextFileSync opts path content = runEffectFn3 _writeTextFileSync opts (toStringOrUrl path) content

chmod :: forall a. IsStringOrUrl a => Int -> a -> Aff Unit
chmod mode path = runAsyncEffect2 _chmod (toStringOrUrl path) mode

chown :: forall a. IsStringOrUrl a => Maybe Int -> Maybe Int -> a -> Aff Unit
chown uid' gid' path = runAsyncEffect3 _chown (toStringOrUrl path) (toNullable uid') (toNullable gid')

copyFile :: forall a b. IsStringOrUrl a => IsStringOrUrl b => a -> b -> Aff Unit
copyFile from to = runAsyncEffect2 _copyFile (toStringOrUrl from) (toStringOrUrl to)

create :: forall a. IsStringOrUrl a => a -> Aff FsFile
create path = runAsyncEffect1 _create (toStringOrUrl path)

link :: String -> String -> Aff Unit
link oldPath newPath = runAsyncEffect2 _link oldPath newPath

mkdir :: forall a. IsStringOrUrl a => MkdirOptions -> a -> Aff Unit
mkdir opts path = runAsyncEffect2 _mkdir opts (toStringOrUrl path)

open :: forall a. IsStringOrUrl a => OpenOptions -> a -> Aff FsFile
open opts path = runAsyncEffect2 _open opts (toStringOrUrl path)

readFile :: forall a. IsStringOrUrl a => a -> Aff Uint8Array
readFile path = runAsyncEffect1 _readFile (toStringOrUrl path)

readTextFile :: forall a. IsStringOrUrl a => a -> Aff String
readTextFile path = runAsyncEffect1 _readTextFile (toStringOrUrl path)

remove :: forall a. IsStringOrUrl a => Boolean -> a -> Aff Unit
remove recursive path = runAsyncEffect2 _remove (toStringOrUrl path) recursive

rename :: forall a b. IsStringOrUrl a => IsStringOrUrl b => a -> b -> Aff Unit
rename oldPath newPath = runAsyncEffect2 _rename (toStringOrUrl oldPath) (toStringOrUrl newPath)

data SymlinkType = File | Dir | Junction

symlinkTypeToString :: SymlinkType -> String
symlinkTypeToString = case _ of
  File -> "file"
  Dir -> "dir"
  Junction -> "junction"

symlink :: forall a b. IsStringOrUrl a => IsStringOrUrl b => Maybe SymlinkType -> a -> b -> Aff Unit
symlink symlinkType oldPath newPath =
  let symlinkType' = toNullable $ symlinkTypeToString <$> symlinkType
  in runAsyncEffect3 _symlink (toStringOrUrl oldPath) (toStringOrUrl newPath) symlinkType'

truncate :: Maybe Int -> FsFile -> Aff Unit
truncate size file = runAsyncEffect2 _truncate file (toNullable size)

umask :: Maybe Int -> Effect Int
umask mask = runEffectFn1 _umask (toNullable mask)

writeFile :: forall a. IsStringOrUrl a => WriteFileOptions -> a -> Uint8Array -> Aff Unit
writeFile opts path content = runAsyncEffect3 _writeFile opts (toStringOrUrl path) content

writeTextFile :: forall a. IsStringOrUrl a => WriteFileOptions -> a -> String -> Aff Unit
writeTextFile opts path content = runAsyncEffect3 _writeTextFile opts (toStringOrUrl path) content

-- Additional file system operations

-- Directory reading with simple DirEntry representation
foreign import data DirEntry :: Type

readDir :: forall a. IsStringOrUrl a => a -> Aff (Array DirEntry)
readDir path = runAsyncEffect1 _readDir (toStringOrUrl path)

stat :: forall a. IsStringOrUrl a => a -> Aff FileInfo
stat path = runAsyncEffect1 _stat (toStringOrUrl path)

lstat :: forall a. IsStringOrUrl a => a -> Aff FileInfo
lstat path = runAsyncEffect1 _lstat (toStringOrUrl path)

realPath :: forall a. IsStringOrUrl a => a -> Aff String
realPath path = runAsyncEffect1 _realPath (toStringOrUrl path)

readLink :: forall a. IsStringOrUrl a => a -> Aff String
readLink path = runAsyncEffect1 _readLink (toStringOrUrl path)

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

makeTempDir :: MakeTempOptions -> Aff String
makeTempDir opts = runAsyncEffect1 _makeTempDir opts

makeTempDirSync :: MakeTempOptions -> Effect String
makeTempDirSync = runEffectFn1 _makeTempDirSync

makeTempFile :: MakeTempOptions -> Aff String
makeTempFile opts = runAsyncEffect1 _makeTempFile opts

makeTempFileSync :: MakeTempOptions -> Effect String
makeTempFileSync = runEffectFn1 _makeTempFileSync

-- File time modification functions

utime :: forall a. IsStringOrUrl a => Number -> Number -> a -> Aff Unit
utime atime mtime path = runAsyncEffect3 _utime (toStringOrUrl path) atime mtime

utimeSync :: forall a. IsStringOrUrl a => Number -> Number -> a -> Effect Unit
utimeSync atime mtime path = runEffectFn3 _utimeSync (toStringOrUrl path) atime mtime

-- File system watching functions and types

-- | Watch file system changes at specified paths
watchFs :: Array String -> Boolean -> Effect FsWatcher
watchFs paths recursive = runEffectFn2 _watchFs paths { recursive }
