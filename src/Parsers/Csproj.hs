module Parsers.Csproj
    (
        parseCsproj
    )
    where

import Types
import Utils.Basics
import Parsers.Xml

import Data.Foldable (find)
import Data.Maybe (catMaybes)
import Text.XML.Light.Types


parseCsproj :: FilePath -> IO [PkgRef]
parseCsproj filename = do
    elts <- loadElements filename "PackageReference"
    return $ elts
        |> fmap readPkg
        |> catMaybes



readPkg :: Element -> Maybe PkgRef
readPkg Element { elAttribs } = do
        ver  <- getAttr "Version" elAttribs
        name <- getAttr "Include" elAttribs
        return PkgRef { name = name, ver = ver }
