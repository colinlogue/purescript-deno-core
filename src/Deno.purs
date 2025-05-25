module Deno
  ( consoleSize
  ) where

import Effect (Effect)

foreign import consoleSize :: Effect { columns :: Int, rows :: Int }
