# Deno HTTP Server PureScript Bindings

PureScript bindings for the [Deno HTTP Server API](https://docs.deno.com/api/deno/http-server).

## Features

- Full bindings for Deno's HTTP server
- Start HTTP and HTTPS servers
- Type-safe interfaces for server configuration
- Support for request/response handling using Web Fetch API types
- Server lifecycle management (start, listen, close)

## Usage Example

```purescript
import Prelude

import Deno.HttpServer as HttpServer
import Deno.HttpServer.Response as Response
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Web.Fetch.Response (Response)

main = launchAff_ do
  let serverOptions = 
        { port: 8000
        , hostname: "localhost"
        , handler: \req -> do
            -- Handle request and return Response
            liftEffect $ Response.text "Hello from Deno HTTP server!"
        , onListen: \info -> log $ "Server listening on " <> info.hostname <> ":" <> show info.port
        , onError: \err -> liftEffect $ Response.text "Server error" -- In a real app, would return appropriate error response
        , signal: abortController.signal
        }
  
  -- Start the server
  HttpServer.serve serverOptions
```