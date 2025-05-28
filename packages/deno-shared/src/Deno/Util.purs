module Deno.Util where

import Prelude

import Data.Either (Either(..))
import Effect (Effect)
import Effect.Aff (Aff, makeAff)
import Effect.Exception (Error)
import Effect.Uncurried (EffectFn1, EffectFn2, EffectFn3, EffectFn4, EffectFn5, EffectFn6, EffectFn7, mkEffectFn1, runEffectFn2, runEffectFn3, runEffectFn4, runEffectFn5, runEffectFn6, runEffectFn7)

type AffCallback a = Either Error a -> Effect Unit

onSuccess :: forall r. AffCallback r -> EffectFn1 r Unit
onSuccess cb = mkEffectFn1 $ cb <<< Right

onError :: forall r. AffCallback r -> EffectFn1 Error Unit
onError cb = mkEffectFn1 $ cb <<< Left

runAsyncEffect0 :: forall r. EffectFn2 (EffectFn1 r Unit) (EffectFn1 Error Unit) Unit -> Aff r
runAsyncEffect0 f = makeAff \cb -> runEffectFn2 f (onSuccess cb) (onError cb) *> mempty

runAsyncEffect1 :: forall a r. EffectFn3 a (EffectFn1 r Unit) (EffectFn1 Error Unit) Unit -> a -> Aff r
runAsyncEffect1 f a = makeAff \cb -> runEffectFn3 f a (onSuccess cb) (onError cb) *> mempty

runAsyncEffect2 :: forall a b r. EffectFn4 a b (EffectFn1 r Unit) (EffectFn1 Error Unit) Unit -> a -> b -> Aff r
runAsyncEffect2 f a b = makeAff \cb -> runEffectFn4 f a b (onSuccess cb) (onError cb) *> mempty

runAsyncEffect3 :: forall a b c r. EffectFn5 a b c (EffectFn1 r Unit) (EffectFn1 Error Unit) Unit -> a -> b -> c -> Aff r
runAsyncEffect3 f a b c = makeAff \cb -> runEffectFn5 f a b c (onSuccess cb) (onError cb) *> mempty

runAsyncEffect4 :: forall a b c d r. EffectFn6 a b c d (EffectFn1 r Unit) (EffectFn1 Error Unit) Unit -> a -> b -> c -> d -> Aff r
runAsyncEffect4 f a b c d = makeAff \cb -> runEffectFn6 f a b c d (onSuccess cb) (onError cb) *> mempty

runAsyncEffect5 :: forall a b c d e r. EffectFn7 a b c d e (EffectFn1 r Unit) (EffectFn1 Error Unit) Unit -> a -> b -> c -> d -> e -> Aff r
runAsyncEffect5 f a b c d e = makeAff \cb -> runEffectFn7 f a b c d e (onSuccess cb) (onError cb) *> mempty