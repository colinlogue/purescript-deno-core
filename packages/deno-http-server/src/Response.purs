module Deno.HttpServer.Response
  ( ResponseInit
  , Response
  , json
  , text
  ) where

import Prelude

import Deno.HttpServer.Foreign (Foreign, unsafeToForeign)
import Effect (Effect)

-- | Response object from Web API
foreign import data Response :: Type

-- | Response initialization options
type ResponseInit =
  { status :: Int         -- Status code (e.g., 200, 404)
  , statusText :: String  -- Status text (e.g., "OK", "Not Found")
  , headers :: Headers    -- Response headers
  }

-- | Headers object from Web API
foreign import data Headers :: Type

-- | Create a JSON response
foreign import json :: forall a. a -> Effect Response

-- | Create a text response
foreign import text :: String -> Effect Response