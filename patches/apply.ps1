if (Test-Path "$PSScriptRoot\node_c_embed_windows.patch") {
    git apply ..\patches\node_c_embed_windows.patch
}

Set-Location -Path "$PSScriptRoot\..\node"

# Apply patches from $SCRIPT_DIR\all
Get-ChildItem -Path "$PSScriptRoot\all" -Filter *.patch | ForEach-Object {
    Write-Host "Applying $($_.FullName)"
    git apply $_.FullName
}

# Apply patches from the directory passed as argument ($args[0])
$targetDir = Join-Path $PSScriptRoot $args[0]
Get-ChildItem -Path $targetDir -Filter *.patch | ForEach-Object {
    if (-Not (Test-Path $_.FullName)) {
        return
    }
    Write-Host "Applying $($_.FullName)"
    git apply $_.FullName
}
