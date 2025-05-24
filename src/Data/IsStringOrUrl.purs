module Data.IsStringOrUrl where

import Unsafe.Coerce (unsafeCoerce)
import Web.URL (URL)


foreign import data StringOrUrl :: Type

class IsStringOrUrl a where
  toStringOrUrl :: a -> StringOrUrl

instance IsStringOrUrl String where
  toStringOrUrl = unsafeCoerce

instance IsStringOrUrl URL where
  toStringOrUrl = unsafeCoerce
