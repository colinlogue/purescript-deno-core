module Deno.FileSystem.FileInfo
  ( FileInfo
  , JSDate
  , isFile
  , isDirectory
  , isSymlink
  , size
  , mtime
  , atime
  , birthtime
  , ctime
  , dev
  , ino
  , mode
  , nlink
  , uid
  , gid
  , rdev
  , blksize
  , blocks
  , isBlockDevice
  , isCharDevice
  , isFifo
  , isSocket
  ) where

import Prelude

import Data.Maybe (Maybe)
import Data.Nullable (Nullable, toMaybe)
import Effect (Effect)
import Effect.Uncurried (EffectFn1, runEffectFn1)

foreign import data FileInfo :: Type

-- Basic file type properties

foreign import _isFile :: EffectFn1 FileInfo Boolean

isFile :: FileInfo -> Effect Boolean
isFile = runEffectFn1 _isFile

foreign import _isDirectory :: EffectFn1 FileInfo Boolean

isDirectory :: FileInfo -> Effect Boolean
isDirectory = runEffectFn1 _isDirectory

foreign import _isSymlink :: EffectFn1 FileInfo Boolean

isSymlink :: FileInfo -> Effect Boolean
isSymlink = runEffectFn1 _isSymlink

-- Size property

foreign import _size :: EffectFn1 FileInfo Number

size :: FileInfo -> Effect Number
size = runEffectFn1 _size

-- Time properties (nullable Date objects)

foreign import _mtime :: EffectFn1 FileInfo (Nullable JSDate)

mtime :: FileInfo -> Effect (Maybe JSDate)
mtime fileInfo = toMaybe <$> runEffectFn1 _mtime fileInfo

foreign import _atime :: EffectFn1 FileInfo (Nullable JSDate)

atime :: FileInfo -> Effect (Maybe JSDate)
atime fileInfo = toMaybe <$> runEffectFn1 _atime fileInfo

foreign import _birthtime :: EffectFn1 FileInfo (Nullable JSDate)

birthtime :: FileInfo -> Effect (Maybe JSDate)
birthtime fileInfo = toMaybe <$> runEffectFn1 _birthtime fileInfo

foreign import _ctime :: EffectFn1 FileInfo (Nullable JSDate)

ctime :: FileInfo -> Effect (Maybe JSDate)
ctime fileInfo = toMaybe <$> runEffectFn1 _ctime fileInfo

-- File system properties

foreign import _dev :: EffectFn1 FileInfo Number

dev :: FileInfo -> Effect Number
dev = runEffectFn1 _dev

foreign import _ino :: EffectFn1 FileInfo (Nullable Number)

ino :: FileInfo -> Effect (Maybe Number)
ino fileInfo = toMaybe <$> runEffectFn1 _ino fileInfo

foreign import _mode :: EffectFn1 FileInfo (Nullable Number)

mode :: FileInfo -> Effect (Maybe Number)
mode fileInfo = toMaybe <$> runEffectFn1 _mode fileInfo

foreign import _nlink :: EffectFn1 FileInfo (Nullable Number)

nlink :: FileInfo -> Effect (Maybe Number)
nlink fileInfo = toMaybe <$> runEffectFn1 _nlink fileInfo

foreign import _uid :: EffectFn1 FileInfo (Nullable Number)

uid :: FileInfo -> Effect (Maybe Number)
uid fileInfo = toMaybe <$> runEffectFn1 _uid fileInfo

foreign import _gid :: EffectFn1 FileInfo (Nullable Number)

gid :: FileInfo -> Effect (Maybe Number)
gid fileInfo = toMaybe <$> runEffectFn1 _gid fileInfo

foreign import _rdev :: EffectFn1 FileInfo (Nullable Number)

rdev :: FileInfo -> Effect (Maybe Number)
rdev fileInfo = toMaybe <$> runEffectFn1 _rdev fileInfo

foreign import _blksize :: EffectFn1 FileInfo (Nullable Number)

blksize :: FileInfo -> Effect (Maybe Number)
blksize fileInfo = toMaybe <$> runEffectFn1 _blksize fileInfo

foreign import _blocks :: EffectFn1 FileInfo (Nullable Number)

blocks :: FileInfo -> Effect (Maybe Number)
blocks fileInfo = toMaybe <$> runEffectFn1 _blocks fileInfo

-- Device type properties (nullable Boolean objects)

foreign import _isBlockDevice :: EffectFn1 FileInfo (Nullable Boolean)

isBlockDevice :: FileInfo -> Effect (Maybe Boolean)
isBlockDevice fileInfo = toMaybe <$> runEffectFn1 _isBlockDevice fileInfo

foreign import _isCharDevice :: EffectFn1 FileInfo (Nullable Boolean)

isCharDevice :: FileInfo -> Effect (Maybe Boolean)
isCharDevice fileInfo = toMaybe <$> runEffectFn1 _isCharDevice fileInfo

foreign import _isFifo :: EffectFn1 FileInfo (Nullable Boolean)

isFifo :: FileInfo -> Effect (Maybe Boolean)
isFifo fileInfo = toMaybe <$> runEffectFn1 _isFifo fileInfo

foreign import _isSocket :: EffectFn1 FileInfo (Nullable Boolean)

isSocket :: FileInfo -> Effect (Maybe Boolean)
isSocket fileInfo = toMaybe <$> runEffectFn1 _isSocket fileInfo

-- JSDate foreign type (for date properties)
foreign import data JSDate :: Type
