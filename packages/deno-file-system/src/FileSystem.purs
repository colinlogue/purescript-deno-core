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
  , utime
  , utimeSync
  , watchFs
  , writeFile
  , writeTextFile
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

foreign import _chmod :: EffectFn4 StringOrUrl Int (EffectFn1 Unit Unit) (EffectFn1 Error Unit) Unit

chmod :: forall a. IsStringOrUrl a => Int -> a -> Aff Unit
chmod mode path = runAsyncEffect2 _chmod (toStringOrUrl path) mode

foreign import _chown :: EffectFn5 StringOrUrl (Nullable Int) (Nullable Int) (EffectFn1 Unit Unit) (EffectFn1 Error Unit) Unit

chown :: forall a. IsStringOrUrl a => Maybe Int -> Maybe Int -> a -> Aff Unit
chown uid' gid' path = runAsyncEffect3 _chown (toStringOrUrl path) (toNullable uid') (toNullable gid')

foreign import _copyFile :: EffectFn4 StringOrUrl StringOrUrl (EffectFn1 Unit Unit) (EffectFn1 Error Unit) Unit

copyFile :: forall a b. IsStringOrUrl a => IsStringOrUrl b => a -> b -> Aff Unit
copyFile from to = runAsyncEffect2 _copyFile (toStringOrUrl from) (toStringOrUrl to)

foreign import _create :: EffectFn3 StringOrUrl (EffectFn1 FsFile Unit) (EffectFn1 Error Unit) Unit

create :: forall a. IsStringOrUrl a => a -> Aff FsFile
create path = runAsyncEffect1 _create (toStringOrUrl path)

foreign import _link :: EffectFn4 String String (EffectFn1 Unit Unit) (EffectFn1 Error Unit) Unit

link :: String -> String -> Aff Unit
link oldPath newPath = runAsyncEffect2 _link oldPath newPath

foreign import _mkdir :: EffectFn4 MkdirOptions StringOrUrl (EffectFn1 Unit Unit) (EffectFn1 Error Unit) Unit

mkdir :: forall a. IsStringOrUrl a => MkdirOptions -> a -> Aff Unit
mkdir opts path = runAsyncEffect2 _mkdir opts (toStringOrUrl path)

foreign import _open :: EffectFn4 OpenOptions StringOrUrl (EffectFn1 FsFile Unit) (EffectFn1 Error Unit) Unit

open :: forall a. IsStringOrUrl a => OpenOptions -> a -> Aff FsFile
open opts path = runAsyncEffect2 _open opts (toStringOrUrl path)

foreign import _readFile :: EffectFn3 StringOrUrl (EffectFn1 Uint8Array Unit) (EffectFn1 Error Unit) Unit

readFile :: forall a. IsStringOrUrl a => a -> Aff Uint8Array
readFile path = runAsyncEffect1 _readFile (toStringOrUrl path)

foreign import _readTextFile :: EffectFn3 StringOrUrl (EffectFn1 String Unit) (EffectFn1 Error Unit) Unit

readTextFile :: forall a. IsStringOrUrl a => a -> Aff String
readTextFile path = runAsyncEffect1 _readTextFile (toStringOrUrl path)

foreign import _remove :: EffectFn4 StringOrUrl Boolean (EffectFn1 Unit Unit) (EffectFn1 Error Unit) Unit

remove :: forall a. IsStringOrUrl a => Boolean -> a -> Aff Unit
remove recursive path = runAsyncEffect2 _remove (toStringOrUrl path) recursive

foreign import _rename :: EffectFn4 StringOrUrl StringOrUrl (EffectFn1 Unit Unit) (EffectFn1 Error Unit) Unit

rename :: forall a b. IsStringOrUrl a => IsStringOrUrl b => a -> b -> Aff Unit
rename oldPath newPath = runAsyncEffect2 _rename (toStringOrUrl oldPath) (toStringOrUrl newPath)

data SymlinkType = File | Dir | Junction

symlinkTypeToString :: SymlinkType -> String
symlinkTypeToString = case _ of
  File -> "file"
  Dir -> "dir"
  Junction -> "junction"

foreign import _symlink :: EffectFn5 StringOrUrl StringOrUrl (Nullable String) (EffectFn1 Unit Unit) (EffectFn1 Error Unit) Unit

symlink :: forall a b. IsStringOrUrl a => IsStringOrUrl b => Maybe SymlinkType -> a -> b -> Aff Unit
symlink symlinkType oldPath newPath =
  let symlinkType' = toNullable $ symlinkTypeToString <$> symlinkType
  in runAsyncEffect3 _symlink (toStringOrUrl oldPath) (toStringOrUrl newPath) symlinkType'

foreign import _truncate :: EffectFn4 FsFile (Nullable Int) (EffectFn1 Unit Unit) (EffectFn1 Error Unit) Unit

truncate :: Maybe Int -> FsFile -> Aff Unit
truncate size file = runAsyncEffect2 _truncate file (toNullable size)

foreign import _umask :: EffectFn1 (Nullable Int) Int

umask :: Maybe Int -> Effect Int
umask mask = runEffectFn1 _umask (toNullable mask)

foreign import _writeFile :: EffectFn5 WriteFileOptions StringOrUrl Uint8Array (EffectFn1 Unit Unit) (EffectFn1 Error Unit) Unit

writeFile :: forall a. IsStringOrUrl a => WriteFileOptions -> a -> Uint8Array -> Aff Unit
writeFile opts path content = runAsyncEffect3 _writeFile opts (toStringOrUrl path) content

foreign import _writeTextFile :: EffectFn5 WriteFileOptions StringOrUrl String (EffectFn1 Unit Unit) (EffectFn1 Error Unit) Unit

writeTextFile :: forall a. IsStringOrUrl a => WriteFileOptions -> a -> String -> Aff Unit
writeTextFile opts path content = runAsyncEffect3 _writeTextFile opts (toStringOrUrl path) content

-- Additional file system operations

-- Directory reading with simple DirEntry representation
foreign import data DirEntry :: Type

foreign import _readDir :: EffectFn3 StringOrUrl (EffectFn1 (Array DirEntry) Unit) (EffectFn1 Error Unit) Unit

readDir :: forall a. IsStringOrUrl a => a -> Aff (Array DirEntry)
readDir path = runAsyncEffect1 _readDir (toStringOrUrl path)

foreign import _stat :: EffectFn3 StringOrUrl (EffectFn1 FileInfo Unit) (EffectFn1 Error Unit) Unit

stat :: forall a. IsStringOrUrl a => a -> Aff FileInfo
stat path = runAsyncEffect1 _stat (toStringOrUrl path)

foreign import _lstat :: EffectFn3 StringOrUrl (EffectFn1 FileInfo Unit) (EffectFn1 Error Unit) Unit

lstat :: forall a. IsStringOrUrl a => a -> Aff FileInfo
lstat path = runAsyncEffect1 _lstat (toStringOrUrl path)

foreign import _realPath :: EffectFn3 StringOrUrl (EffectFn1 String Unit) (EffectFn1 Error Unit) Unit

realPath :: forall a. IsStringOrUrl a => a -> Aff String
realPath path = runAsyncEffect1 _realPath (toStringOrUrl path)

foreign import _readLink :: EffectFn3 StringOrUrl (EffectFn1 String Unit) (EffectFn1 Error Unit) Unit

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

foreign import _makeTempDir :: EffectFn3 MakeTempOptions (EffectFn1 String Unit) (EffectFn1 Error Unit) Unit

makeTempDir :: MakeTempOptions -> Aff String
makeTempDir opts = runAsyncEffect1 _makeTempDir opts

foreign import _makeTempDirSync :: EffectFn1 MakeTempOptions String

makeTempDirSync :: MakeTempOptions -> Effect String
makeTempDirSync = runEffectFn1 _makeTempDirSync

foreign import _makeTempFile :: EffectFn3 MakeTempOptions (EffectFn1 String Unit) (EffectFn1 Error Unit) Unit

makeTempFile :: MakeTempOptions -> Aff String
makeTempFile opts = runAsyncEffect1 _makeTempFile opts

foreign import _makeTempFileSync :: EffectFn1 MakeTempOptions String

makeTempFileSync :: MakeTempOptions -> Effect String
makeTempFileSync = runEffectFn1 _makeTempFileSync

-- File time modification functions

foreign import _utime :: EffectFn5 StringOrUrl Number Number (EffectFn1 Unit Unit) (EffectFn1 Error Unit) Unit

utime :: forall a. IsStringOrUrl a => Number -> Number -> a -> Aff Unit
utime atime mtime path = runAsyncEffect3 _utime (toStringOrUrl path) atime mtime

foreign import _utimeSync :: EffectFn3 StringOrUrl Number Number Unit

utimeSync :: forall a. IsStringOrUrl a => Number -> Number -> a -> Effect Unit
utimeSync atime mtime path = runEffectFn3 _utimeSync (toStringOrUrl path) atime mtime

-- File system watching functions and types

foreign import _watchFs :: EffectFn2 (Array String) { recursive :: Boolean } FsWatcher

-- | Watch file system changes at specified paths
watchFs :: Array String -> Boolean -> Effect FsWatcher
watchFs paths recursive = runEffectFn2 _watchFs paths { recursive }
