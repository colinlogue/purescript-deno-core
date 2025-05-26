module Deno.FileSystem.DirEntry
  ( DirEntry
  , name
  , isFile
  , isDirectory
  , isSymlink
  ) where

import Prelude

import Effect (Effect)
import Effect.Uncurried (EffectFn1, runEffectFn1)

foreign import data DirEntry :: Type

foreign import _name :: EffectFn1 DirEntry String

name :: DirEntry -> Effect String
name = runEffectFn1 _name

foreign import _isFile :: EffectFn1 DirEntry Boolean

isFile :: DirEntry -> Effect Boolean
isFile = runEffectFn1 _isFile

foreign import _isDirectory :: EffectFn1 DirEntry Boolean

isDirectory :: DirEntry -> Effect Boolean
isDirectory = runEffectFn1 _isDirectory

foreign import _isSymlink :: EffectFn1 DirEntry Boolean

isSymlink :: DirEntry -> Effect Boolean
isSymlink = runEffectFn1 _isSymlink
