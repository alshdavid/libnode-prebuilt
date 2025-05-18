cd $PSScriptRoot\..\node
git apply ..\patches\node_c_embed.patch

if (Test-Path "$PSScriptRoot\node_c_embed_windows.patch") {
    git apply ..\patches\node_c_embed_windows.patch
}
