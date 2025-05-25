module Deno.CommandOptions where

import Prelude

import Data.Function.Uncurried (Fn2, runFn2)

foreign import data CommandOptions :: Type

foreign import empty :: CommandOptions

foreign import args :: Array String -> CommandOptions

foreign import env :: forall r. Record r -> CommandOptions

foreign import combine :: Fn2 CommandOptions CommandOptions CommandOptions

instance Semigroup CommandOptions where
  append = runFn2 combine

instance Monoid CommandOptions where
  mempty = empty
