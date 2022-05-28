{-# LANGUAGE AllowAmbiguousTypes
           , DataKinds
           , KindSignatures
           , MultiParamTypeClasses
           , Rank2Types
           , ScopedTypeVariables
           , TypeApplications #-}

{- | Utility functions for using 'Storable' to access record fields of data structures.
  
     Functions in this module rely on the [TypeApplications](https://ghc.gitlab.haskell.org/ghc/doc/users_guide/exts/type_applications.html) pragma (the 'Offset' class itself doesn't).
 -}

module Foreign.Storable.Offset
  ( -- * Offset
    Offset (..)
  , offset
    -- * Helper functions
  , pokeField
  ) where

import           Foreign.Ptr
import           Foreign.Storable
import           GHC.Records
import           GHC.TypeLits



class Offset (x :: Symbol) r where
  -- | Byte distance between the start of datatype @r@ within memory and its field @x@.
  rawOffset :: Int

-- | Advances a pointer based on field's 'Offset', inheriting field's type.
--
--   Resulting pointer can be used to 'peek' or 'poke' the field directly.
offset :: forall x r a. (HasField x r a, Offset x r) => Ptr r -> Ptr a
offset = (`plusPtr` rawOffset @x @r)



-- | Retrieves the field and 'poke's it at proper 'offset'.
--   
--   Useful for declaring 'poke' for the entire datatype.
pokeField :: forall x r a. (HasField x r a, Offset x r, Storable a) => Ptr r -> r -> IO ()
pokeField ptr = poke (offset @x @r ptr) . getField @x @r
