module TreeBuilder
    where

import Types
import Utils.Basics
import Parsers.Csproj
import Parsers.Nuspec

import Data.Tree
import System.Directory
import Control.Monad (filterM)
import Data.Char (toLower)
import Control.Monad.Trans.Maybe
import Control.Monad.Trans.Class (lift)
import Data.Maybe (fromMaybe)



buildTrees :: FilePath -> IO [Tree PkgRef]
buildTrees prjFile = do
    roots <- parseCsproj prjFile
    refs <- unfoldForestM getDeps' (inc 0 roots)
    return $ (fmap . fmap) pkgRef refs


data PkgRefNod = PkgRefNod
    { pkgRef :: PkgRef
    , level :: Int }


getDeps' :: PkgRefNod -> IO (PkgRefNod, [PkgRefNod])
getDeps' pkg@PkgRefNod {level = pkgLevel} =
    if pkgLevel > 5
    then
        return (pkg, [])
    else
        do
            nuspecFile <- runMaybeT $ findNuspecFile $ pkgRef pkg
            res <- nuspecFile
                |> fmap parseNuspec
                |> sequenceA
            return $ res
                |> fmap (\xs -> (pkg, inc (level pkg) xs))
                |> fromMaybe (pkg, [])


inc :: Int -> [PkgRef] -> [PkgRefNod]
inc level = fmap (\r -> PkgRefNod { pkgRef = r, level = level + 1 })


getDeps :: PkgRef -> IO [PkgRef]
getDeps pkg = do
    nuspecFile <- runMaybeT $ findNuspecFile pkg
    res <- nuspecFile
        |> fmap parseNuspec
        |> sequenceA
    return $ res |> fromMaybe []


nugetPackageFolder :: FilePath
nugetPackageFolder = "C:\\Users\\vlad\\.nuget\\packages"


findNuspecFile :: PkgRef -> MaybeT IO FilePath
findNuspecFile PkgRef { name, ver } =
    let
        smallName = fmap toLower name
        file = nugetPackageFolder ++ "\\" ++ smallName ++ "\\" ++ ver ++ "\\" ++ smallName ++ ".nuspec"
    in
        MaybeT $ do
            exist <- doesFileExist file
            return $ if exist then Just file else Nothing
