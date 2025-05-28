module Deno.Subprocess.Command
  ( Command
  , new
  , output
  , outputSync
  , spawn
  ) where

import Prelude

import Data.IsStringOrUrl (class IsStringOrUrl, StringOrUrl, toStringOrUrl)
import Deno.Subprocess.ChildProcess (ChildProcess, CommandOutput)
import Deno.Subprocess.CommandOptions (CommandOptions)
import Effect (Effect)
import Effect.Aff (Aff)
import Deno.Util (runAsyncEffect1)
import Effect.Exception (Error)
import Effect.Uncurried (EffectFn1, EffectFn2, EffectFn3, runEffectFn1, runEffectFn2)

foreign import data Command :: Type

foreign import _new :: EffectFn2 CommandOptions StringOrUrl Command

new :: forall a. IsStringOrUrl a => CommandOptions -> a -> Effect Command
new opts command = runEffectFn2 _new opts (toStringOrUrl command)

-- Methods

foreign import _output :: EffectFn3 Command (EffectFn1 CommandOutput Unit) (EffectFn1 Error Unit) Unit

output :: Command -> Aff CommandOutput
output cmd = runAsyncEffect1 _output cmd

foreign import _outputSync :: EffectFn1 Command CommandOutput

outputSync :: Command -> Effect CommandOutput
outputSync = runEffectFn1 _outputSync

foreign import _spawn :: EffectFn1 Command ChildProcess

spawn :: Command -> Effect ChildProcess
spawn = runEffectFn1 _spawn
