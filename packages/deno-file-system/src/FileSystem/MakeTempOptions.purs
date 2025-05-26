module Deno.FileSystem.MakeTempOptions where

import Prelude

import Data.Function.Uncurried (Fn2, runFn2)


foreign import data MakeTempOptions :: Type

foreign import dir :: String -> MakeTempOptions

foreign import prefix :: String -> MakeTempOptions

foreign import suffix :: String -> MakeTempOptions

foreign import empty :: MakeTempOptions

foreign import combine :: Fn2 MakeTempOptions MakeTempOptions MakeTempOptions

instance Semigroup MakeTempOptions where
  append = runFn2 combine

instance Monoid MakeTempOptions where
  mempty = empty
