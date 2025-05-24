module Web.Streams.Writer
  ( Writer
  , write
  , close
  , abort
  , closed
  , ready
  , releaseLock
  ) where

import Data.Maybe (Maybe)
import Effect (Effect)
import Prelude (Unit)
import Promise (Promise)

-- Writer is a higher-kinded type that takes a chunk type parameter
foreign import data Writer :: Type -> Type

-- Methods
foreign import write :: forall chunk. chunk -> Writer chunk -> Effect (Promise Unit)

foreign import close :: forall chunk. Writer chunk -> Effect (Promise Unit)

foreign import abort :: forall chunk. Maybe String -> Writer chunk -> Effect (Promise Unit)

foreign import releaseLock :: forall chunk. Writer chunk -> Effect Unit

-- Properties (Promises)
foreign import closed :: forall chunk. Writer chunk -> Effect (Promise Unit)

foreign import ready :: forall chunk. Writer chunk -> Effect (Promise Unit)
