# Overview

I've written this as a learning exercise.

Given the path of a .csproj file (C#), it will
- extract the package references from it (xml parsing)
- for each one it will find the dependency tree by looking up and parsing their nuspec files (xml parsing) in your nuget cache folder
- it will then print the dependency trees

# Example output
```
AngleSharp [0.17.1]
|
+- System.Buffers [4.5.1]
|  |
|  +- System.Diagnostics.Debug [4.3.0]
|  |  |
|  |  +- Microsoft.NETCore.Platforms [1.1.0]
|  |  |
|  |  +- Microsoft.NETCore.Targets [1.1.0]
|  |  |
|  |  `- System.Runtime [4.3.0]
|  |     |
|  |     +- Microsoft.NETCore.Platforms [1.1.0]
|  |     |
|  |     `- Microsoft.NETCore.Targets [1.1.0]
|  |
|  +- System.Diagnostics.Tracing [4.3.0]
|  |  |
|  |  +- Microsoft.NETCore.Platforms [1.1.0]
|  |  |
|  |  +- Microsoft.NETCore.Targets [1.1.0]
|  |  |
|  |  `- System.Runtime [4.3.0]
|  |     |
|  |     +- Microsoft.NETCore.Platforms [1.1.0]
|  |     |
|  |     `- Microsoft.NETCore.Targets [1.1.0]
|  |
|  +- System.Resources.ResourceManager [4.3.0]
```
