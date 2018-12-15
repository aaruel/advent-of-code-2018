module Main where

class Rect a where
    width :: a -> Float
    height :: a -> Float

dist :: Rect a => a -> a -> Float
dist a b = (width a - width b) + (height a - height b)

main = do
    print([1,2,3])
