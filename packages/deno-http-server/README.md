# Deno HTTP Server PureScript Bindings

PureScript bindings for the [Deno HTTP Server API](https://docs.deno.com/api/deno/http-server).

## Features

- Full bindings for Deno's HTTP server
- Start HTTP and HTTPS servers
- Type-safe interfaces for server configuration
- Support for request/response handling
- Server lifecycle management (start, listen, close)

## Usage Example

```purescript
import Prelude

import Deno.HttpServer as HttpServer
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Effect.Console (log)

main = launchAff_ do
  let serverOptions = 
        { port: 8000
        , hostname: "localhost"
        , handler: \req -> do
            -- Handle request and return Response
            pure $ new Response("Hello from Deno HTTP server!")
        , onListen: \info -> log $ "Server listening on " <> info.hostname <> ":" <> show info.port
        , onError: \err -> new Response("Server error", { status: 500 })
        , signal: abortController.signal
        }
  
  -- Start the server
  HttpServer.serve serverOptions
```