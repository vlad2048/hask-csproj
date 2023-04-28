module Parsers.Nuspec
    (
        parseNuspec,
    )
    where

import Types
import Utils.Basics
import Parsers.Xml

import Data.Foldable (find)
import Data.Maybe (catMaybes, fromMaybe, listToMaybe)
import Text.XML.Light.Types
import Text.XML.Light.Proc
import Data.List (elemIndex, sortOn, reverse)



parseNuspec :: FilePath -> IO [PkgRef]
parseNuspec filename = do
    elts <- loadElements filename "group"
    return $ elts
        |> fmap readGrp
        |> catMaybes
        |> filter (not . null . pkgs)
        |> sortOn (\g -> elemIndex (framework g) fws)
        |> reverse
        |> fmap pkgs
        |> listToMaybe
        |> fromMaybe []


data Grp = Grp
    { framework :: String
    , pkgs :: [PkgRef] }
    deriving (Show)


fws :: [String]
fws = [
        ".NETStandard1.0",
        ".NETStandard1.1",
        ".NETStandard1.2",
        ".NETStandard1.3",
        ".NETStandard1.4",
        ".NETStandard1.5",
        ".NETStandard1.6",
        ".NETStandard2.0",
        ".NETStandard2.1",
        ".NETCore5.0",
        ".NETCore5.0-windows7.0",
        ".NETCore5.0-windows10.0.19041",
        ".NETCore6.0",
        ".NETCore6.0-windows7.0",
        ".NETCore6.0-windows10.0.19041"
      ]


readGrp :: Element -> Maybe Grp
readGrp elt@(Element { elAttribs }) = do
    framework <- getAttr "targetFramework" elAttribs
    let pkgs = elChildren elt |> fmap readPkg |> catMaybes
    return Grp { framework = framework, pkgs = pkgs }
    
readPkg :: Element -> Maybe PkgRef
readPkg Element { elName = QName { qName }, elAttribs } =
    case qName == "dependency" of
        False -> Nothing
        True -> do
            name <- getAttr "id" elAttribs
            ver <- getAttr "version" elAttribs
            return PkgRef { name = name, ver = ver }
    