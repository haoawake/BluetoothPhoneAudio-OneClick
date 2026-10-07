$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

$AppName = 'AudioBridge'
$Runtime = Join-Path $env:LOCALAPPDATA $AppName
$Exe = Join-Path $Runtime 'AudioPlaybackConnector.exe'
$Meta = Join-Path $Runtime 'source.json'
$Api = 'https://api.github.com/repos/Dearkoma/AudioPlaybackConnector/releases/latest'

function Write-Step([string]$Text) {
  Write-Host "[AudioBridge] $Text" -ForegroundColor Cyan
}

function Get-ArchAsset($Release) {
  $is32 = -not [Environment]::Is64BitOperatingSystem
  if ($is32) {
    return $Release.assets | Where-Object { $_.name -match '^AudioPlaybackConnector32-.*\.exe$' } | Select-Object -First 1
  }
  # x64 build also runs under Windows 11 ARM64 x64 emulation.
  return $Release.assets | Where-Object { $_.name -match '^AudioPlaybackConnector64-.*\.exe$' } | Select-Object -First 1
}

function Need-Download($Asset) {
  if (-not (Test-Path $Exe)) { return $true }
  if (-not (Test-Path $Meta)) { return $true }
  try {
    $saved = Get-Content $Meta -Raw | ConvertFrom-Json
    if ($saved.assetId -ne $Asset.id) { return $true }
    if ($Asset.digest -and $Asset.digest -match '^sha256:(.+)$') {
      $expected = $Matches[1].ToLowerInvariant()
      $actual = (Get-FileHash -Algorithm SHA256 $Exe).Hash.ToLowerInvariant()
      if ($actual -ne $expected) { return $true }
    }
    return $false
  } catch {
    return $true
  }
}

try {
  $build = [Environment]::OSVersion.Version.Build
  if ($build -lt 19041) {
    throw '需要 Windows 10 2004（Build 19041）或更新版本。'
  }

  New-Item -ItemType Directory -Force -Path $Runtime | Out-Null
  Write-Step '检查最新版蓝牙音频接收组件…'
  $headers = @{ 'User-Agent' = $AppName; 'Accept' = 'application/vnd.github+json' }
  $release = Invoke-RestMethod -Uri $Api -Headers $headers
  $asset = Get-ArchAsset $release
  if (-not $asset) { throw '没有找到适合当前 Windows 架构的发布文件。' }

  if (Need-Download $asset) {
    Write-Step "下载 $($asset.name)…"
    $tmp = "$Exe.download"
    Remove-Item $tmp -Force -ErrorAction SilentlyContinue
    Invoke-WebRequest -Uri $asset.browser_download_url -Headers $headers -OutFile $tmp

    if ($asset.digest -and $asset.digest -match '^sha256:(.+)$') {
      $expected = $Matches[1].ToLowerInvariant()
      $actual = (Get-FileHash -Algorithm SHA256 $tmp).Hash.ToLowerInvariant()
      if ($actual -ne $expected) {
        Remove-Item $tmp -Force -ErrorAction SilentlyContinue
        throw "SHA-256 校验失败。期望 $expected，实际 $actual。"
      }
      Write-Step 'SHA-256 校验通过。'
    } else {
      Write-Warning 'GitHub Release 没有提供 digest，本次无法执行 SHA-256 对照校验。'
    }

    Move-Item $tmp $Exe -Force
    @{
      tag = $release.tag_name
      assetId = $asset.id
      assetName = $asset.name
      digest = $asset.digest
      source = 'https://github.com/Dearkoma/AudioPlaybackConnector'
      downloadedAt = (Get-Date).ToString('o')
    } | ConvertTo-Json | Set-Content -Encoding UTF8 $Meta
  } else {
    Write-Step "已是最新版：$($release.tag_name)"
  }

  Write-Step '启动蓝牙音频接收器。点击通知区域图标，选择已经配对的手机。'
  Start-Process -FilePath $Exe -WorkingDirectory $Runtime
  Start-Sleep -Milliseconds 500
  exit 0
} catch {
  Write-Host ''
  Write-Host "错误：$($_.Exception.Message)" -ForegroundColor Red
  Write-Host ''
  Write-Host '排查：' -ForegroundColor Yellow
  Write-Host '1. 确认 Windows 10 2004+ / Windows 11。'
  Write-Host '2. 先在「设置 → 蓝牙和设备」把手机与电脑配对。'
  Write-Host '3. 确认网络可以访问 github.com。'
  Write-Host '4. 可运行同目录的 Diagnose.ps1 查看基础诊断。'
  exit 1
}
