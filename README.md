# Overview

I've written this as a learning exercise.

Given the path of a .csproj file (C#), it will
- extract the package references from it (xml parsing)
- for each one it will find the dependency tree by looking up and parsing their nuspec files (xml parsing) in your nuget cache folder
- it will then print the dependency trees (forest)
