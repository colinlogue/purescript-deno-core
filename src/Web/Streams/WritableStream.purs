module Web.Streams.WritableStream
  ( WritableStream
  , locked
  , abort
  , close
  , getWriter
  ) where

import Data.Maybe (Maybe)
import Effect (Effect)
import Prelude (Unit)
import Promise (Promise)
import Web.Streams.Writer (Writer)

-- WritableStream is a higher-kinded type that takes a chunk type parameter
foreign import data WritableStream :: Type -> Type

-- Properties
foreign import locked :: forall chunk. WritableStream chunk -> Effect Boolean

-- Methods
foreign import abort :: forall chunk. Maybe String -> WritableStream chunk -> Effect (Promise Unit)

foreign import close :: forall chunk. WritableStream chunk -> Effect (Promise Unit)

foreign import getWriter :: forall chunk. WritableStream chunk -> Effect (Writer chunk)
