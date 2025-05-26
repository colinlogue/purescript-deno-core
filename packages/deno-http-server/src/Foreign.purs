module Deno.HttpServer.Foreign where

-- | Foreign data type for passing JavaScript objects
foreign import data Foreign :: Type

-- | Unsafe conversion to foreign data
foreign import unsafeToForeign :: forall a. a -> Foreign