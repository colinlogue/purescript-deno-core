module Deno.IO
  ( consoleSize
  , stderr
  , stdin
  , stdout
  ) where

import Deno.IO.OutputStream (OutputStream)
import Effect (Effect)


foreign import consoleSize :: Effect { columns :: Int, rows :: Int }

foreign import stderr :: OutputStream

foreign import stdin :: OutputStream

foreign import stdout :: OutputStream
