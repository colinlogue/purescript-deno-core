module Deno.ChildProcess
  ( ChildProcess
  , pid
  ) where

foreign import data ChildProcess :: Type

foreign import pid :: ChildProcess -> Int
