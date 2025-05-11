cd $PSScriptRoot\..\node
git diff --staged > ..\patches\node_c_embed.patch
cd ..