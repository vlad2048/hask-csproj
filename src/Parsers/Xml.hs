module Parsers.Xml
    (
        loadElements,
        getAttr
    )
    where

import Utils.Basics

import Data.Foldable (find)
import Text.XML.Light.Types
import Text.XML.Light.Input
import Text.XML.Light.Proc


loadElements :: FilePath -> String -> IO [Element]
loadElements file n = do
    fileContent <- readFile file
    let roots = parseXML fileContent
    return $ getElements roots n

getAttr :: String -> [Attr] -> Maybe String
getAttr name attrs = do
    attr <- find (isName name . attrKey) attrs
    return $ attrVal attr
    where
        isName :: String -> QName -> Bool
        isName s QName { qName } = qName == s


getElements :: [Content] -> String -> [Element]
getElements nodes n =
    filter (\e -> let name = qName (elName e) in name == n) $
    go $ onlyElems nodes
    where
        go :: [Element] -> [Element]
        go xs = xs >>= (\x -> x : go (elChildren x))
