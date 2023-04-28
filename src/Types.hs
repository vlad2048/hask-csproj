module Types where


data PkgRef = PkgRef
    { name :: String
    , ver :: String }
    deriving (Eq)

instance Show PkgRef where
    show PkgRef { name, ver } = name ++ " [" ++ ver ++ "]"
