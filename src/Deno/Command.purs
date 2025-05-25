module Deno.Command
  ( Command
  , new
  ) where

import Prelude

import Data.IsStringOrUrl (class IsStringOrUrl, StringOrUrl, toStringOrUrl)
import Deno.CommandOptions (CommandOptions)
import Effect (Effect)
import Effect.Uncurried (EffectFn2, runEffectFn2)

foreign import data Command :: Type

foreign import _new :: EffectFn2 CommandOptions StringOrUrl Command

new :: forall a. IsStringOrUrl a => CommandOptions -> a -> Effect Command
new opts command = runEffectFn2 _new opts (toStringOrUrl command)
