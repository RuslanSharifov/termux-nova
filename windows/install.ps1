# ============================================================
#  termux-nova installer for Windows - by rugo
#  Run with: install.cmd   (or: powershell -ExecutionPolicy Bypass -File install.ps1)
# ============================================================
$ErrorActionPreference = 'Stop'
$src = $PSScriptRoot
$app = Join-Path $env:APPDATA 'termux-nova'

Write-Host '== termux-nova installer by rugo ==' -ForegroundColor Cyan
Write-Host ''

Write-Host '[1/5] Copying files...'
New-Item -ItemType Directory -Force -Path $app | Out-Null
Copy-Item (Join-Path $src 'nova.ps1') $app -Force
Copy-Item (Join-Path $src 'themes.json') $app -Force
Copy-Item (Join-Path $src '..\assets\banner-font.txt') (Join-Path $app 'banner-font.txt') -Force
Set-Content -Path (Join-Path $app 'nova.cmd') -Encoding ASCII -Value @(
  '@echo off',
  'powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0nova.ps1" %*'
)

Write-Host '[2/5] Adding termux-nova to your PATH (so "nova" works in cmd)...'
$userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
if (-not ($userPath -and (($userPath -split ';') -contains $app))) {
  $new = if ($userPath) { $userPath.TrimEnd(';') + ';' + $app } else { $app }
  [Environment]::SetEnvironmentVariable('Path', $new, 'User')
}

$nova = Join-Path $app 'nova.ps1'
Write-Host '[3/5] Installing cmd.exe hooks (banner after cls, custom commands, auto restore)...'
& powershell -NoProfile -ExecutionPolicy Bypass -File $nova hook

Write-Host '[4/5] Auto restore'
$ans = Read-Host 'Enable auto restore on every cmd start? [Y/n]'
if ($ans -match '^(n|no)$') { & powershell -NoProfile -ExecutionPolicy Bypass -File $nova auto off }
else                        { & powershell -NoProfile -ExecutionPolicy Bypass -File $nova auto on }

Write-Host '[5/5] Applying default theme (nova-dark)...'
& powershell -NoProfile -ExecutionPolicy Bypass -File $nova set nova-dark

Write-Host ''
Write-Host 'Done! Open a NEW Windows Terminal (or cmd) window.' -ForegroundColor Green
Write-Host 'Type "nova console" to open the settings menu.'
