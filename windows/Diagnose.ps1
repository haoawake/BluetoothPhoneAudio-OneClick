$ErrorActionPreference = 'Continue'
Write-Host '=== BluetoothPhoneAudio-OneClick diagnostics ===' -ForegroundColor Cyan
Write-Host "Time: $(Get-Date -Format o)"
Write-Host "Windows: $([Environment]::OSVersion.VersionString)"
Write-Host "64-bit OS: $([Environment]::Is64BitOperatingSystem)"
Write-Host "64-bit process: $([Environment]::Is64BitProcess)"
Write-Host ''
Write-Host 'Bluetooth devices:' -ForegroundColor Yellow
try {
  Get-PnpDevice -Class Bluetooth | Sort-Object Status, FriendlyName | Format-Table -AutoSize Status, FriendlyName, InstanceId
} catch {
  Write-Host "Get-PnpDevice failed: $($_.Exception.Message)"
}
Write-Host ''
$runtime = Join-Path $env:LOCALAPPDATA 'BluetoothPhoneAudio-OneClick'
Write-Host "Runtime directory: $runtime"
if (Test-Path $runtime) {
  Get-ChildItem $runtime | Format-Table -AutoSize Name, Length, LastWriteTime
}
Write-Host ''
Write-Host '如果显示 Connected 但没声音：在托盘弹窗中点一次「重连」。' -ForegroundColor Yellow
