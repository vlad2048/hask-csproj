module Utils.Basics
    (
        (|>)
    )
    where

(|>) :: a -> (a -> b) -> b
(|>) = flip ($)
