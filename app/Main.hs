module Main (main) where

import Lib
import Types
import Utils.Basics
import Parsers.Csproj
import Parsers.Nuspec
import TreeBuilder

import Text.XML.Light.Types
import Text.XML.Light.Input
import Text.XML.Light.Output
import Text.XML.Light.Lexer
import Text.XML.Light.Proc
import Text.XML.Light.Cursor
import Data.Maybe (catMaybes)
import Data.Foldable (find)
import Control.Monad
import Data.Tree



fileCsproj, fileNuspec :: FilePath
fileCsproj = "C:\\Dev_Learn\\Haskell\\projs\\p01-csproj-analyzer\\_infos\\files\\PowWeb.csproj"
fileNuspec = "C:\\Dev_Learn\\Haskell\\projs\\p01-csproj-analyzer\\_infos\\files\\system.linq.expressions.nuspec"


main :: IO ()
main = do
    trees <- buildTrees fileCsproj
    trees
        |> (fmap . fmap) show
        |> drawForest
        |> putStrLn

    


