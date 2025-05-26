module Test.Deno where

import Prelude

import Deno.IO (consoleSize) as Deno
import Effect (Effect)
import Effect.Class (liftEffect)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldSatisfy)

foreign import stdoutIsTerminal :: Effect Boolean

spec :: Spec Unit
spec = do
  describe "Deno Core" do
    describe "Console utilities" do
      it "should get console size when in terminal" do
        liftEffect stdoutIsTerminal >>= flip when do
          size <- liftEffect Deno.consoleSize
          size.columns `shouldSatisfy` (_ > 0)
          size.rows `shouldSatisfy` (_ > 0)
