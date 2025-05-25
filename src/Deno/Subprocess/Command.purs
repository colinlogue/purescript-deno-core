module Deno.Subprocess.Command
  ( Command
  , new
  , output
  , outputSync
  , spawn
  ) where

import Prelude

import Data.Either (Either(..))
import Data.IsStringOrUrl (class IsStringOrUrl, StringOrUrl, toStringOrUrl)
import Deno.Subprocess.ChildProcess (ChildProcess, CommandOutput)
import Deno.Subprocess.CommandOptions (CommandOptions)
import Effect (Effect)
import Effect.Aff (Aff, makeAff)
import Effect.Exception (Error)
import Effect.Uncurried (EffectFn1, EffectFn2, EffectFn3, mkEffectFn1, runEffectFn1, runEffectFn2, runEffectFn3)

foreign import data Command :: Type

foreign import _new :: EffectFn2 CommandOptions StringOrUrl Command

new :: forall a. IsStringOrUrl a => CommandOptions -> a -> Effect Command
new opts command = runEffectFn2 _new opts (toStringOrUrl command)

-- Methods

foreign import _output :: EffectFn3 Command (EffectFn1 CommandOutput Unit) (EffectFn1 Error Unit) Unit

output :: Command -> Aff CommandOutput
output cmd = makeAff \cb ->
  let
    onSuccess = cb <<< Right
    onError = cb <<< Left
  in
    runEffectFn3 _output cmd (mkEffectFn1 onSuccess) (mkEffectFn1 onError) *> mempty

foreign import _outputSync :: EffectFn1 Command CommandOutput

outputSync :: Command -> Effect CommandOutput
outputSync = runEffectFn1 _outputSync

foreign import _spawn :: EffectFn1 Command ChildProcess

spawn :: Command -> Effect ChildProcess
spawn = runEffectFn1 _spawn
