module Deno.IO
  ( consoleSize
  ) where

import Effect (Effect)
import IO.OutputChannel (OutputStream)



foreign import consoleSize :: Effect { columns :: Int, rows :: Int }

foreign import stderr :: OutputStream

foreign import stdin :: OutputStream

foreign import stdout :: OutputStream
