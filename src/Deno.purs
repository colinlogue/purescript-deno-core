module Deno where

import Prelude

import Data.Either (Either(..))
import Data.IsStringOrUrl (class IsStringOrUrl, StringOrUrl, toStringOrUrl)
import Data.Maybe (Maybe, maybe)
import Data.Nullable (Nullable, toNullable)
import Deno.FsFile (FsFile)
import Deno.MkdirOptions (MkdirOptions)
import Deno.OpenOptions (OpenOptions)
import Deno.WriteFileOptions (WriteFileOptions)
import Effect (Effect)
import Effect.Aff (Aff, Error, makeAff)
import Effect.Uncurried (EffectFn1, EffectFn3, EffectFn4, EffectFn5, mkEffectFn1, runEffectFn1, runEffectFn3, runEffectFn4, runEffectFn5)


foreign import _mkdir :: EffectFn4 MkdirOptions StringOrUrl (Effect Unit) (EffectFn1 Error Unit) Unit

mkdir :: forall a. IsStringOrUrl a => MkdirOptions -> a -> Aff Unit
mkdir opts path = makeAff \cb ->
  let
    onSuccess = cb (Right unit)
    onFailure = cb <<< Left
  in
    runEffectFn4 _mkdir opts (toStringOrUrl path) onSuccess (mkEffectFn1 onFailure) *> mempty

foreign import _readTextFile :: EffectFn3 StringOrUrl (EffectFn1 String Unit) (EffectFn1 Error Unit) Unit

readTextFile :: forall a. IsStringOrUrl a => a -> Aff String
readTextFile path = makeAff \cb ->
  let
    onSuccess = cb <<< Right
    onFailure = cb <<< Left
  in
    runEffectFn3 _readTextFile (toStringOrUrl path) (mkEffectFn1 onSuccess) (mkEffectFn1 onFailure) *> mempty

foreign import _writeTextFile :: EffectFn5 WriteFileOptions String String (Effect Unit) (EffectFn1 Error Unit) Unit

writeTextFile :: WriteFileOptions -> String -> String -> Aff Unit
writeTextFile opts path content = makeAff \cb ->
  let
    onSuccess = cb (Right unit)
    onFailure = cb <<< Left
  in
    runEffectFn5 _writeTextFile opts path content onSuccess (mkEffectFn1 onFailure) *> mempty

foreign import _open :: EffectFn4 OpenOptions StringOrUrl (EffectFn1 FsFile Unit) (EffectFn1 Error Unit) Unit

open :: forall a. IsStringOrUrl a => OpenOptions -> a -> Aff FsFile
open opts path = makeAff \cb ->
  let
    onSuccess = cb <<< Right
    onFailure = cb <<< Left
  in
    runEffectFn4 _open opts (toStringOrUrl path) (mkEffectFn1 onSuccess) (mkEffectFn1 onFailure) *> mempty

foreign import _chdir :: EffectFn1 StringOrUrl Unit

chdir :: forall a. IsStringOrUrl a => a -> Effect Unit
chdir path = runEffectFn1 _chdir $ toStringOrUrl path

foreign import _exit :: EffectFn1 Int Unit

exit :: Int -> Effect Unit
exit code = runEffectFn1 _exit code

foreign import _chmod :: EffectFn4 StringOrUrl Int (Effect Unit) (EffectFn1 Error Unit) Unit

chmod :: forall a. IsStringOrUrl a => a -> Int -> Aff Unit
chmod path mode = makeAff \cb ->
  let
    onSuccess = cb (Right unit)
    onFailure = cb <<< Left
  in
    runEffectFn4 _chmod (toStringOrUrl path) mode onSuccess (mkEffectFn1 onFailure) *> mempty

foreign import _chown :: EffectFn5 StringOrUrl (Nullable Int) (Nullable Int) (Effect Unit) (EffectFn1 Error Unit) Unit

chown :: forall a. IsStringOrUrl a => a -> Maybe Int -> Maybe Int -> Aff Unit
chown path uid gid = makeAff \cb ->
  let
    onSuccess = cb (Right unit)
    onFailure = cb <<< Left
  in
    runEffectFn5 _chown (toStringOrUrl path) (toNullable uid) (toNullable gid) onSuccess (mkEffectFn1 onFailure) *> mempty
