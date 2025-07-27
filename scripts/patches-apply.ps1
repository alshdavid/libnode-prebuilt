$root = dirname $PSScriptRoot

Get-ChildItem -Path "$root\patches\all" -Filter *.pr | ForEach-Object {
  Write-Host "Applying $($_.FullName)"
  $url = Get-Content -Path "$($_.FullName)"
  curl -L -o "$($_.Directory)/$($_.BaseName).pr.patch" "$url.patch"
}

$targetDir = Join-Path $root "patches" $args[0]
if (Test-Path "$targetDir") {
  Get-ChildItem -Path $targetDir -Filter *.pr | ForEach-Object {
    if (-Not (Test-Path $_.FullName)) {
      return
    }

    Write-Host "Applying $($_.FullName)"
    $url = Get-Content -Path "$($_.FullName)"
    curl -L -o "$($_.Directory)/$($_.BaseName).pr.patch" "$url.patch"
  }
}

Set-Location -Path "$root\node"

# Apply patches from $SCRIPT_DIR\all
Get-ChildItem -Path "$PSScriptRoot\all" -Filter *.patch | ForEach-Object {
  Write-Host "Applying $($_.FullName)"
  git apply $_.FullName
}

# Apply patches from the directory passed as argument ($args[0])
$targetDir = Join-Path $PSScriptRoot $args[0]
if (Test-Path "$targetDir") {
  Get-ChildItem -Path $targetDir -Filter *.patch | ForEach-Object {
    if (-Not (Test-Path $_.FullName)) {
      return
    }
    Write-Host "Applying $($_.FullName)"
    git apply $_.FullName
  }
}

