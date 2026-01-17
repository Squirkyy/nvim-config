Remove-Item -Path "$env:USERPROFILE\AppData\Local\nvim" -Recurse -Force

New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\AppData\Local\nvim" -Target (Get-Location)
