module Deno.HttpServer.Response
  ( json
  , text
  ) where

import Prelude

import Effect (Effect)
import Web.Fetch.Response (Response)
import Web.Fetch.Response as WebResponse
import Web.Fetch.Headers as Headers

-- | Create a JSON response
json :: forall a. a -> Effect Response
json = WebResponse.json

-- | Create a text response
text :: String -> Effect Response
text content = do
  headers <- Headers.fromFoldable [Tuple "Content-Type" "text/plain"]
  WebResponse.new content { headers: headers }