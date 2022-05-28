# storable-offset

Tiny helper library that provides a way to access fields of `Storable` data structures.

Given an instance

```haskell
{-# LANGUAGE DataKinds
           , MultiParamTypeClasses #-}

instance Offset "fieldName" DataType where rawOffset = #{offset data_type, field_name}
```

, you can now `peek`/`poke` `fieldName` directly using

```haskell
{-# LANGUAGE TypeApplications #-}

peek $ offset @"fieldName" (ptr @DataType)

poke (offset @"fieldName" ptr) (val @DataType)
```
