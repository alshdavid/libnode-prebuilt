function prepare() {
  Get-Command clang
  clang --version
}

function clone() {
  git clone "$env:NODEJS_GIT" --branch "$env:NODEJS_BRANCH" --depth=1 .\node
}

function build() {
  Set-Location .\node
  .\vcbuild.bat x64 dll openssl-no-asm
  Set-Location ..
}

function copy-release() {
  if (Test-Path .\release\libnode-windows-amd64) {
    Remove-Item -Recurse -Force .\release\libnode-windows-amd64
  }
  New-Item -ItemType "Directory" -Force -Path .\release\libnode-windows-amd64
  Copy-Item -Path .\node\out\Release\libnode.dll -Destination .\release\libnode-windows-amd64
  Copy-Item -Path .\node\out\Release\node.exe -Destination .\release\libnode-windows-amd64
}

&$args[0]