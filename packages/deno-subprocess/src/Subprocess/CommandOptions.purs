module Deno.Subprocess.CommandOptions
  ( CommandOptions
  , StdioOption(..)
  , class IsCommandEnv
  , empty
  , args
  , cwd
  , clearEnv
  , env
  , uid
  , gid
  , stdin
  , stdout
  , stderr
  , windowsRawArguments
  ) where

import Prelude

import Data.Function.Uncurried (Fn2, runFn2)
import Data.IsStringOrUrl (class IsStringOrUrl, StringOrUrl, toStringOrUrl)
import JS.Fetch.AbortController (AbortSignal)
import Prim.RowList (class RowToList, RowList)
import Prim.RowList as RowList
import Unsafe.Coerce (unsafeCoerce)


foreign import data CommandOptions :: Type

data StdioOption = Piped | Inherit | Null

stdioOptionToString :: StdioOption -> String
stdioOptionToString = case _ of
  Piped -> "piped"
  Inherit -> "inherit"
  Null -> "null"

foreign import empty :: CommandOptions

foreign import args :: Array String -> CommandOptions

foreign import _cwd :: StringOrUrl -> CommandOptions

cwd :: forall a. IsStringOrUrl a => a -> CommandOptions
cwd path = _cwd (toStringOrUrl path)

foreign import clearEnv :: Boolean -> CommandOptions

foreign import _env :: CommandEnv -> CommandOptions

env :: forall r rl. RowToList r rl => IsCommandEnv rl => Record r -> CommandOptions
env = unsafeCoerce >>> _env

foreign import uid :: Int -> CommandOptions

foreign import gid :: Int -> CommandOptions

foreign import signal :: AbortSignal -> CommandOptions

foreign import _stdin :: String -> CommandOptions
foreign import _stdout :: String -> CommandOptions
foreign import _stderr :: String -> CommandOptions

stdin :: StdioOption -> CommandOptions
stdin opt = _stdin (stdioOptionToString opt)

stdout :: StdioOption -> CommandOptions
stdout opt = _stdout (stdioOptionToString opt)

stderr :: StdioOption -> CommandOptions
stderr opt = _stderr (stdioOptionToString opt)

foreign import windowsRawArguments :: Boolean -> CommandOptions

foreign import combine :: Fn2 CommandOptions CommandOptions CommandOptions

instance Semigroup CommandOptions where
  append = runFn2 combine

instance Monoid CommandOptions where
  mempty = empty

foreign import data CommandEnv :: Type

class IsCommandEnv (rl :: RowList Type)
instance IsCommandEnv RowList.Nil
instance (IsCommandEnv tail) => IsCommandEnv (RowList.Cons label String tail)
