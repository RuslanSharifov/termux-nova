# ============================================================
#  termux-nova for Windows - theme switcher & command manager
#  by rugo - MIT License
# ============================================================
param(
  [Parameter(Position = 0)] [string]$Action = 'help',
  [Parameter(ValueFromRemainingArguments = $true)] [string[]]$Rest = @()
)

$NovaVersion  = '2.1.0'
$NovaOwner    = 'RuslanSharifov'
$NovaRepo     = 'RuslanSharifov/termux-nova'
$RepoTtlHours = 6

$AppDir     = Join-Path $env:APPDATA 'termux-nova'
$CacheDir   = Join-Path $env:LOCALAPPDATA 'termux-nova\cache'
$ScriptPath = Join-Path $AppDir 'nova.ps1'
$ConfFile   = Join-Path $AppDir 'config'
$BannerFont = Join-Path $AppDir 'banner-font.txt'
$CmdsFile   = Join-Path $AppDir 'commands'
$MacroFile  = Join-Path $AppDir 'macros.txt'
$ThemesFile = Join-Path $AppDir 'themes.json'
$RepoCache  = Join-Path $CacheDir 'repo.json'
$AutoRunKey = 'HKCU:\Software\Microsoft\Command Processor'
$Reserved   = @('cd','dir','cls','clear','nova','exit','echo','set','call','copy','del','move',
                'type','ren','start','ver','color','title','if','for','goto','pause','rem')

try { [Console]::OutputEncoding = [Text.Encoding]::UTF8 } catch {}

# ---------- helpers ----------
function Write-Ok([string]$msg)  { Write-Host "✔ $msg" -ForegroundColor Green }
function Write-Err([string]$msg) { Write-Host "✘ $msg" -ForegroundColor Red }

function Pause-Menu { Write-Host ''; Read-Host 'Press Enter to continue' | Out-Null }

# ---------- config ----------
function Get-Conf([string]$Key, [string]$Default) {
  if (Test-Path $ConfFile) {
    $v = $null
    foreach ($l in Get-Content $ConfFile) {
      if ($l -match "^$Key=(.*)$") { $v = $Matches[1] }
    }
    if ($v) { return $v }
  }
  return $Default
}

function Set-Conf([string]$Key, [string]$Value) {
  New-Item -ItemType Directory -Force -Path $AppDir | Out-Null
  $lines = @()
  if (Test-Path $ConfFile) { $lines = @(Get-Content $ConfFile | Where-Object { $_ -notmatch "^$Key=" }) }
  $lines += "$Key=$Value"
  Set-Content -Path $ConfFile -Value $lines -Encoding UTF8
}

function Switch-Conf([string]$Key) {
  if ((Get-Conf $Key 'on') -eq 'on') { Set-Conf $Key 'off' } else { Set-Conf $Key 'on' }
}

# ---------- banner + GitHub stats ----------
function Show-RepoBlock {
  $stale = $true
  if (Test-Path $RepoCache) {
    $age = (Get-Date) - (Get-Item $RepoCache).LastWriteTime
    $stale = $age.TotalHours -gt $RepoTtlHours
  }
  if ($stale) {
    New-Item -ItemType Directory -Force -Path $CacheDir | Out-Null
    if (-not (Test-Path $RepoCache)) { Set-Content -Path $RepoCache -Value '' }
    (Get-Item $RepoCache).LastWriteTime = Get-Date
    Start-Process -WindowStyle Hidden -FilePath 'powershell' `
      -ArgumentList @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', "`"$ScriptPath`"", 'refreshrepo') | Out-Null
  }
  $d = $null
  if ((Test-Path $RepoCache) -and (Get-Item $RepoCache).Length -gt 0) {
    try { $d = Get-Content $RepoCache -Raw | ConvertFrom-Json } catch { $d = $null }
  }
  $stars  = if ($d -and $null -ne $d.stargazers_count) { $d.stargazers_count } else { '…' }
  $forks  = if ($d -and $null -ne $d.forks_count)      { $d.forks_count }      else { '…' }
  $issues = if ($d -and $null -ne $d.open_issues_count){ $d.open_issues_count } else { '…' }
  $pushed = if ($d -and $d.pushed_at) { ([string]$d.pushed_at).Substring(0, 10) } else { '…' }

  Write-Host "   GitHub  : github.com/$NovaOwner" -ForegroundColor DarkGray
  Write-Host "   Repo    : github.com/$NovaRepo" -ForegroundColor DarkGray
  Write-Host '   ' -NoNewline
  Write-Host "★ $stars stars" -ForegroundColor Yellow -NoNewline
  Write-Host "   ⑂ $forks forks" -ForegroundColor Cyan -NoNewline
  Write-Host "   ● $issues issues" -ForegroundColor Green -NoNewline
  Write-Host "   ↻ $pushed" -ForegroundColor Magenta
}

function Invoke-RefreshRepo {
  try {
    New-Item -ItemType Directory -Force -Path $CacheDir | Out-Null
    $r = Invoke-RestMethod -Uri "https://api.github.com/repos/$NovaRepo" `
          -Headers @{ Accept = 'application/vnd.github+json'; 'User-Agent' = 'termux-nova' } -TimeoutSec 10
    if ($null -ne $r.stargazers_count) {
      $r | ConvertTo-Json -Depth 5 | Set-Content -Path $RepoCache -Encoding UTF8
    }
  } catch {}
}

# ---------- Windows CMD screen clearing ----------
# Perform clearing and banner rendering in the SAME PowerShell process.
# The old doskey macro chained a separate CMD 'cls' and PowerShell invocation;
# the second process could leave stale text/art above the new banner.
function Clear-NovaScreen {
  try {
    [Console]::Out.Flush()
    [Console]::Clear()
    [Console]::SetCursorPosition(0, 0)
  } catch {
    # Fallback for hosts where the .NET console handle is unavailable.
    if ($env:OS -eq 'Windows_NT' -and $env:ComSpec) {
      & $env:ComSpec /d /c cls
    } else {
      Clear-Host
    }
  }
}

# ---------- editable block banner ----------
function Set-BannerText([string]$Text) {
  if ([string]::IsNullOrWhiteSpace($Text) -or $Text.Length -gt 64 -or $Text -match '[\x00-\x1F\x7F]') {
    Write-Err 'Use 1-64 printable characters. Newlines/control characters are not allowed.'
    return $false
  }
  Set-Conf 'BANNER_TEXT' $Text
  Write-Ok "Banner text saved: $Text"
  return $true
}

function Write-BannerArt {
  $text = Get-Conf 'BANNER_TEXT' 'NOVA'
  if ($text -eq 'NOVA') {
    $art = @(
      ' ███╗   ██╗ ██████╗ ██╗   ██╗ █████╗',
      ' ████╗  ██║██╔═══██╗██║   ██║██╔══██╗',
      ' ██╔██╗ ██║██║   ██║██║   ██║███████║',
      ' ██║╚██╗██║██║   ██║╚██╗ ██╔╝██╔══██║',
      ' ██║ ╚████║╚██████╔╝ ╚████╔╝ ██║  ██║',
      ' ╚═╝  ╚═══╝ ╚═════╝   ╚═══╝  ╚═╝  ╚═╝'
    )
    foreach ($l in $art) { Write-Host $l -ForegroundColor Cyan }
    return
  }
  if (-not (Test-Path $BannerFont)) {
    Write-Host " $text" -ForegroundColor Cyan
    return
  }
  $glyphs = @{}
  foreach ($line in [IO.File]::ReadAllLines($BannerFont, [Text.Encoding]::UTF8)) {
    if ($line.StartsWith('#')) { continue }
    $parts = $line.Split('|')
    if ($parts.Length -eq 9) { $glyphs[$parts[0]] = @($parts[1..8]) }
  }
  $max = 8
  try {
    $cols = [Console]::WindowWidth
    if ($cols -gt 0) { $max = [Math]::Max(1, [int][Math]::Floor(($cols - 1) / 9)) }
  } catch {}
  $chars = $text.ToCharArray()
  for ($offset = 0; $offset -lt $chars.Length; $offset += $max) {
    $last = [Math]::Min($chars.Length, $offset + $max)
    for ($row = 0; $row -lt 8; $row++) {
      $pieces = New-Object 'System.Collections.Generic.List[string]'
      for ($j = $offset; $j -lt $last; $j++) {
        $cp = '{0:X4}' -f [int]$chars[$j]
        if (-not $glyphs.ContainsKey($cp)) { $cp = '003F' }
        [void]$pieces.Add($glyphs[$cp][$row].Replace('#', '█').Replace('.', ' '))
      }
      Write-Host ($pieces -join ' ') -ForegroundColor Cyan
    }
  }
}

function Menu-BannerText {
  Clear-NovaScreen
  Show-Banner
  Write-Host "Current banner text: $(Get-Conf 'BANNER_TEXT' 'NOVA')"
  Write-Host 'Letters, digits and punctuation render as blocks; unsupported symbols show as ?.'
  Write-Host 'Maximum 64 characters. Long text wraps to fit the window.'
  $text = Read-Host 'New banner text (Enter = reset to NOVA)'
  if ([string]::IsNullOrEmpty($text)) { $text = 'NOVA' }
  if (Set-BannerText $text) {
    Write-Host 'Preview:'
    Write-BannerArt
  }
  Pause-Menu
}

function Show-Banner {
  Write-BannerArt
  Write-Host "   Termux UI Theme Switcher  v$NovaVersion  by rugo" -ForegroundColor DarkGray
  Show-RepoBlock
  Write-Host ''
}

# ---------- arrow-key / number menu ----------
function Select-Menu {
  param([string]$Title, [string[]]$Items, [switch]$NoBanner)
  if (-not $Items -or $Items.Count -eq 0) { return -1 }
  $sel = 0
  $buf = ''
  while ($true) {
    Clear-NovaScreen
    if (-not $NoBanner) { Show-Banner }
    if ($Title) { Write-Host $Title -ForegroundColor Yellow }
    for ($i = 0; $i -lt $Items.Count; $i++) {
      $line = '{0}) {1}' -f ($i + 1), $Items[$i]
      if ($i -eq $sel) { Write-Host ('  > ' + $line) -ForegroundColor Cyan }
      else             { Write-Host ('    ' + $line) }
    }
    Write-Host ''
    Write-Host '  Up/Down: move   Enter: select   digits + Enter: choose number   Esc: back' -ForegroundColor DarkGray
    if ($buf) { Write-Host "  Number: $buf" }
    $k = [Console]::ReadKey($true)
    switch ($k.Key) {
      'UpArrow'   { $sel = ($sel - 1 + $Items.Count) % $Items.Count; $buf = '' }
      'DownArrow' { $sel = ($sel + 1) % $Items.Count; $buf = '' }
      'Backspace' { if ($buf.Length -gt 0) { $buf = $buf.Substring(0, $buf.Length - 1) } }
      'Escape'    { return -1 }
      'Enter' {
        if ($buf) {
          $n = [int]$buf
          $buf = ''
          if ($n -ge 1 -and $n -le $Items.Count) { return ($n - 1) }
        } else {
          return $sel
        }
      }
      default {
        if ($k.KeyChar -match '[0-9]') { $buf += $k.KeyChar }
      }
    }
  }
}

# ---------- themes (Windows Terminal color schemes) ----------
function Get-Themes {
  if (Test-Path $ThemesFile) {
    try { return @(Get-Content $ThemesFile -Raw | ConvertFrom-Json) } catch {}
  }
  return @()
}

function Find-WTSettings {
  $paths = @(
    (Join-Path $env:LOCALAPPDATA 'Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json'),
    (Join-Path $env:LOCALAPPDATA 'Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json'),
    (Join-Path $env:LOCALAPPDATA 'Microsoft\Windows Terminal\settings.json')
  )
  foreach ($p in $paths) { if (Test-Path $p) { return $p } }
  return $null
}

function Set-WTTheme([string]$Name) {
  $theme = Get-Themes | Where-Object { $_.name -eq $Name } | Select-Object -First 1
  if (-not $theme) { return $false }
  $path = Find-WTSettings
  if (-not $path) { return $false }
  try {
    $json = Get-Content $path -Raw | ConvertFrom-Json
  } catch {
    Write-Host 'Windows Terminal settings.json could not be parsed (it may contain comments). Theme not applied.' -ForegroundColor Yellow
    return $false
  }
  Copy-Item $path "$path.nova-backup" -Force

  $schemes = @()
  if ($json.PSObject.Properties['schemes'] -and $json.schemes) {
    $schemes = @($json.schemes | Where-Object { $_.name -ne $Name })
  }
  $schemes += $theme
  if ($json.PSObject.Properties['schemes']) { $json.schemes = $schemes }
  else { $json | Add-Member -NotePropertyName schemes -NotePropertyValue $schemes }

  if (-not $json.PSObject.Properties['profiles']) {
    $json | Add-Member -NotePropertyName profiles -NotePropertyValue ([pscustomobject]@{})
  }
  if (-not $json.profiles.PSObject.Properties['defaults']) {
    $json.profiles | Add-Member -NotePropertyName defaults -NotePropertyValue ([pscustomobject]@{})
  }
  if ($json.profiles.defaults.PSObject.Properties['colorScheme']) {
    $json.profiles.defaults.colorScheme = $Name
  } else {
    $json.profiles.defaults | Add-Member -NotePropertyName colorScheme -NotePropertyValue $Name
  }
  $json | ConvertTo-Json -Depth 32 | Set-Content -Path $path -Encoding UTF8
  return $true
}

function Set-Theme([string]$Name) {
  if (-not (Get-Themes | Where-Object { $_.name -eq $Name })) {
    Write-Err "Unknown theme: $Name"
    return $false
  }
  Set-Conf 'THEME' $Name
  if (Set-WTTheme $Name) {
    Set-Conf 'LAST_APPLIED' $Name
    Write-Ok "Theme saved: $Name"
    return $true
  }
  Write-Host "Theme saved as '$Name', but Windows Terminal was not updated." -ForegroundColor Yellow
  Write-Host ("Open Windows Terminal once, then run: nova set $Name") -ForegroundColor Yellow
  return $false
}

# ---------- custom commands (CRUD) ----------
# File format: TRIGGER<TAB>COMMAND   e.g.  npm run full<TAB>npm i && npm run dev

function Read-Cmds {
  if (-not (Test-Path $CmdsFile)) { return @() }
  Get-Content $CmdsFile -Encoding UTF8 | Where-Object { $_ -match "`t" } | ForEach-Object {
    $p = $_ -split "`t", 2
    [pscustomobject]@{ Key = $p[0]; Cmd = $p[1] }
  }
}

function Write-Cmds($Items) {
  New-Item -ItemType Directory -Force -Path $AppDir | Out-Null
  $lines = @($Items | ForEach-Object { "$($_.Key)`t$($_.Cmd)" })
  Set-Content -Path $CmdsFile -Value $lines -Encoding UTF8
  Rebuild-Macros
}

function Test-Key([string]$Key) {
  if ($Key -match '///') { return $false }
  $first = ($Key -split ' ')[0]
  if ($first -notmatch '^[A-Za-z_][A-Za-z0-9_.-]*$') { return $false }
  if ($Reserved -contains $first.ToLower()) { return $false }
  return $true
}

function Normalize-Steps([string]$Raw) {
  $parts = @($Raw -split '///' | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne '' })
  return ($parts -join ' && ')
}

function Add-Cmd([string]$Key, [string]$Steps) {
  $Key = $Key.Trim()
  $cmd = Normalize-Steps $Steps
  if (-not (Test-Key $Key)) { Write-Err "Invalid trigger. Use 'salam' or 'npm run full' (no ///, no reserved words)."; return $false }
  if (-not $cmd) { Write-Err 'Steps are empty.'; return $false }
  $list = @(Read-Cmds)
  if ($list | Where-Object { $_.Key -eq $Key }) { Write-Err "'$Key' already exists. Use Edit."; return $false }
  Write-Cmds (@($list) + [pscustomobject]@{ Key = $Key; Cmd = $cmd })
  Write-Ok "Added: $Key"
  return $true
}

function Update-Cmd([string]$Key, [string]$Steps) {
  $cmd = Normalize-Steps $Steps
  if (-not $cmd) { Write-Err 'Steps are empty.'; return $false }
  $list = @(Read-Cmds)
  if (-not ($list | Where-Object { $_.Key -eq $Key })) { Write-Err "No such command: $Key"; return $false }
  $new = @($list | ForEach-Object { if ($_.Key -eq $Key) { [pscustomobject]@{ Key = $Key; Cmd = $cmd } } else { $_ } })
  Write-Cmds $new
  Write-Ok "Updated: $Key"
  return $true
}

function Remove-Cmd([string]$Key) {
  $list = @(Read-Cmds)
  if (-not ($list | Where-Object { $_.Key -eq $Key })) { Write-Err "No such command: $Key"; return $false }
  Write-Cmds @($list | Where-Object { $_.Key -ne $Key })
  Write-Ok "Deleted: $Key"
  return $true
}

# Writes the doskey macro file: every first word of a trigger becomes a macro
function Rebuild-Macros {
  New-Item -ItemType Directory -Force -Path $AppDir | Out-Null
  $run = "powershell -NoProfile -ExecutionPolicy Bypass -File `"$ScriptPath`""
  $lines = @("cls=$run clearhook")
  $firsts = @(Read-Cmds | ForEach-Object { ($_.Key -split ' ')[0] } | Sort-Object -Unique)
  foreach ($f in $firsts) { $lines += "$f=$run dispatch $f `$*" }
  Set-Content -Path $MacroFile -Value $lines -Encoding ASCII
}

# Called by the macro: runs the chain if the typed line matches a trigger, otherwise runs it as-is
function Invoke-Dispatch([string[]]$Words) {
  $line = (($Words -join ' ')).Trim()
  $best = $null
  foreach ($c in @(Read-Cmds)) {
    if ($line -eq $c.Key -or $line.StartsWith($c.Key + ' ', [StringComparison]::OrdinalIgnoreCase)) {
      if (-not $best -or $c.Key.Length -gt $best.Key.Length) { $best = $c }
    }
  }
  if ($best) {
    Write-Host "▶ $($best.Cmd)" -ForegroundColor Cyan
    & cmd.exe /d /c $best.Cmd
  } else {
    & cmd.exe /d /c $line
  }
}

# ---------- cmd.exe hooks (AutoRun + doskey macros) ----------
function Install-Hooks {
  $run   = "powershell -NoProfile -ExecutionPolicy Bypass -File `"$ScriptPath`""
  $value = "if not defined NOVA_STARTED (set NOVA_STARTED=1 & $run start) & doskey /macrofile=`"$MacroFile`""
  New-Item -Path $AutoRunKey -Force | Out-Null
  Set-ItemProperty -Path $AutoRunKey -Name AutoRun -Value $value
  Rebuild-Macros
}

function Invoke-Start {
  if ((Get-Conf 'AUTO' 'on') -eq 'on') {
    $t = Get-Conf 'THEME' 'nova-dark'
    if ($t -ne (Get-Conf 'LAST_APPLIED' '')) {
      if (Set-WTTheme $t) { Set-Conf 'LAST_APPLIED' $t }
    }
  }
  if ((Get-Conf 'BANNER_ON_START' 'on') -eq 'on') {
    Clear-NovaScreen
    Show-Banner
  }
}

function Clear-Cache {
  if (Test-Path $CacheDir) { Remove-Item -Recurse -Force $CacheDir }
  Write-Ok 'Cache cleared'
}

# ---------- interactive menus ----------
function Menu-Theme {
  $names = @(Get-Themes | ForEach-Object { $_.name })
  if ($names.Count -eq 0) { Write-Err 'No themes found.'; Pause-Menu; return }
  $i = Select-Menu -Title 'Choose a theme' -Items $names
  if ($i -ge 0) { Set-Theme $names[$i] | Out-Null; Pause-Menu }
}

function Read-Steps([string]$Prefill) {
  Write-Host 'Write all steps on ONE line, separated with ///' -ForegroundColor DarkGray
  Write-Host 'Example: npm i /// npm run dev' -ForegroundColor DarkGray
  if ($Prefill) { Write-Host "Current: $Prefill" -ForegroundColor DarkGray }
  return (Read-Host 'Steps')
}

function Menu-AddCommand {
  $key = (Read-Host 'Trigger (e.g. salam or npm run full)').Trim()
  if (-not (Test-Key $key)) { Write-Err "Invalid trigger. Use 'salam' or 'npm run full' (no ///, no reserved words)."; Pause-Menu; return }
  if (@(Read-Cmds) | Where-Object { $_.Key -eq $key }) { Write-Err "'$key' already exists. Use Edit."; Pause-Menu; return }
  $steps = Read-Steps ''
  while ($true) {
    $cmd = Normalize-Steps $steps
    if (-not $cmd) { Write-Err 'Steps are empty.'; $steps = Read-Steps ''; continue }
    Write-Host ''
    Write-Host "  Trigger : $key"
    Write-Host "  Runs    : $cmd"
    $c = Select-Menu -Title 'Save this command?' -Items @('Save', 'Cancel', 'Edit steps') -NoBanner
    if ($c -eq 0) { Add-Cmd $key $steps | Out-Null; break }
    if ($c -eq 1 -or $c -eq -1) { Write-Host 'Cancelled.'; break }
    $steps = Read-Steps $cmd
  }
  Pause-Menu
}

function Menu-EditCommand {
  $list = @(Read-Cmds)
  if ($list.Count -eq 0) { Write-Host 'No custom commands yet.'; Pause-Menu; return }
  $keys = @($list | ForEach-Object { $_.Key })
  $i = Select-Menu -Title 'Choose a command to edit' -Items $keys
  if ($i -lt 0) { return }
  $key = $keys[$i]
  $cur = ($list | Where-Object { $_.Key -eq $key }).Cmd
  $steps = Read-Steps $cur
  if (-not $steps.Trim()) { $steps = $cur }
  $cmd = Normalize-Steps $steps
  Write-Host ''
  Write-Host "  Trigger : $key"
  Write-Host "  Runs    : $cmd"
  $c = Select-Menu -Title 'Save changes?' -Items @('Save', 'Cancel') -NoBanner
  if ($c -eq 0) { Update-Cmd $key $steps | Out-Null }
  Pause-Menu
}

function Menu-DeleteCommand {
  $list = @(Read-Cmds)
  if ($list.Count -eq 0) { Write-Host 'No custom commands yet.'; Pause-Menu; return }
  $keys = @($list | ForEach-Object { $_.Key })
  $i = Select-Menu -Title 'Choose a command to delete' -Items $keys
  if ($i -lt 0) { return }
  $c = Select-Menu -Title "Delete '$($keys[$i])'?" -Items @('Yes, delete', 'No') -NoBanner
  if ($c -eq 0) { Remove-Cmd $keys[$i] | Out-Null }
  Pause-Menu
}

function Menu-Commands {
  while ($true) {
    $list = @(Read-Cmds)
    $title = 'Custom commands:'
    if ($list.Count -gt 0) {
      $title += "`n" + (($list | ForEach-Object { "  $($_.Key)  ->  $($_.Cmd)" }) -join "`n")
    } else {
      $title += "`n  (none yet)"
    }
    $i = Select-Menu -Title $title -Items @('Add', 'Edit', 'Delete', 'Back')
    switch ($i) {
      0 { Menu-AddCommand }
      1 { Menu-EditCommand }
      2 { Menu-DeleteCommand }
      default { return }
    }
  }
}

function Open-Console {
  while ($true) {
    $items = @(
      "Change theme (now: $(Get-Conf 'THEME' 'nova-dark'))",
      "Auto restore: $(Get-Conf 'AUTO' 'on')",
      "Banner on start: $(Get-Conf 'BANNER_ON_START' 'on')",
      "Banner on clear: $(Get-Conf 'BANNER_ON_CLEAR' 'on')",
      "Custom commands ($(@(Read-Cmds).Count))",
      "Banner text: $(Get-Conf 'BANNER_TEXT' 'NOVA')",
      'Clear cache',
      'Reset settings to defaults',
      'Reinstall cmd hooks',
      'Exit'
    )
    $i = Select-Menu -Title 'Settings' -Items $items
    switch ($i) {
      0 { Menu-Theme }
      1 { Switch-Conf 'AUTO' }
      2 { Switch-Conf 'BANNER_ON_START' }
      3 { Switch-Conf 'BANNER_ON_CLEAR' }
      4 { Menu-Commands }
      5 { Menu-BannerText }
      6 { Clear-Cache; Pause-Menu }
      7 {
          Remove-Item -Path $ConfFile -ErrorAction SilentlyContinue
          Set-Conf 'THEME' 'nova-dark'; Set-Conf 'AUTO' 'on'
          Set-Conf 'BANNER_ON_START' 'on'; Set-Conf 'BANNER_ON_CLEAR' 'on'
          Write-Ok 'Settings reset (custom commands kept)'; Pause-Menu
        }
      8 { Install-Hooks; Write-Ok 'Hooks reinstalled. Open a new cmd window.'; Pause-Menu }
      default { return }
    }
  }
}

function Show-Doctor {
  Show-Banner
  $wt = Find-WTSettings
  $ar = (Get-ItemProperty -Path $AutoRunKey -Name AutoRun -ErrorAction SilentlyContinue).AutoRun
  Write-Host "install dir : $AppDir"
  Write-Host "WT settings : $(if ($wt) { $wt } else { 'not found (open Windows Terminal once)' })"
  Write-Host "cmd AutoRun : $(if ($ar -and $ar -match 'nova.ps1') { 'ok' } else { 'MISSING (run: nova hook)' })"
  Write-Host "macros      : $(if (Test-Path $MacroFile) { 'ok' } else { 'missing (run: nova hook)' })"
  Write-Host "custom cmds : $(@(Read-Cmds).Count)"
  Write-Host "repo stats  : $(if ((Test-Path $RepoCache) -and (Get-Item $RepoCache).Length -gt 0) { 'cached' } else { 'not fetched yet' })"
}

function Show-Usage {
@'
Usage: nova <command>

  console                        open the settings menu (arrows / numbers)
  list                           show all themes
  set <theme>                    apply a theme and remember it
  current                        show all current settings
  auto on|off                    restore the saved theme on every start
  banner                         show the banner now
  banner set "<text>"            save custom block banner (1-64 characters)
  banner reset                   restore original NOVA banner
  cmd                            list custom commands
  cmd add "<trigger>" "<steps>"  e.g. nova cmd add "salam" "npm i /// npm run dev"
  cmd edit "<trigger>" "<steps>"
  cmd rm "<trigger>"
  cache clear                    clear cache
  hook                           (re)install cmd.exe hooks
  doctor                         check the installation
  help                           show this screen
'@ | Write-Host
}

# ---------- entry point ----------
switch ($Action.ToLower()) {
  'start'       { Invoke-Start }
  'clearhook'   { Clear-NovaScreen; if ((Get-Conf 'BANNER_ON_CLEAR' 'on') -eq 'on') { Show-Banner } }
  'dispatch'    { Invoke-Dispatch $Rest }
  'refreshrepo' { Invoke-RefreshRepo }
  'banner' {
    if ($Rest.Count -eq 0 -or $Rest[0] -eq 'show') {
      Show-Banner
    } elseif ($Rest[0] -eq 'reset') {
      Set-Conf 'BANNER_TEXT' 'NOVA'
      Show-Banner
    } elseif ($Rest[0] -eq 'set' -and $Rest.Count -ge 2) {
      $newText = ($Rest[1..($Rest.Count - 1)] -join ' ')
      if (Set-BannerText $newText) { Show-Banner }
    } else {
      Write-Host 'Usage: nova banner [set "<text>"|reset]'
    }
  }
  'console'     { Open-Console }
  'menu'        { Open-Console }
  'list' {
    Show-Banner
    $cur = Get-Conf 'THEME' 'nova-dark'
    foreach ($t in @(Get-Themes)) {
      $mark = if ($t.name -eq $cur) { '●' } else { ' ' }
      Write-Host "  $mark $($t.name)"
    }
  }
  'set' {
    Show-Banner
    if ($Rest.Count -lt 1) { Write-Host 'Usage: nova set <theme>' } else { Set-Theme $Rest[0] | Out-Null }
  }
  'current' {
    Show-Banner
    Write-Host "Theme           : $(Get-Conf 'THEME' 'nova-dark')"
    Write-Host "Auto restore    : $(Get-Conf 'AUTO' 'on')"
    Write-Host "Banner on start : $(Get-Conf 'BANNER_ON_START' 'on')"
    Write-Host "Banner on clear : $(Get-Conf 'BANNER_ON_CLEAR' 'on')"
    Write-Host "Custom commands : $(@(Read-Cmds).Count)"
    Write-Host "Banner text     : $(Get-Conf 'BANNER_TEXT' 'NOVA')"
  }
  'auto' {
    Show-Banner
    $mode = ''
    if ($Rest.Count) { $mode = $Rest[0] }
    switch ($mode) {
      'on'  { Set-Conf 'AUTO' 'on';  Write-Ok 'Auto restore enabled' }
      'off' { Set-Conf 'AUTO' 'off'; Write-Ok 'Auto restore disabled' }
      default { Write-Host 'Usage: nova auto on|off' }
    }
  }
  'cmd' {
    Show-Banner
    $sub = if ($Rest.Count) { $Rest[0] } else { 'list' }
    switch ($sub) {
      'list' {
        $list = @(Read-Cmds)
        if ($list.Count -eq 0) { Write-Host 'No custom commands yet.' }
        foreach ($c in $list) { Write-Host "  $($c.Key)  ->  $($c.Cmd)" }
      }
      'add'          { Add-Cmd ([string]$Rest[1]) ([string]$Rest[2]) | Out-Null }
      'edit'         { Update-Cmd ([string]$Rest[1]) ([string]$Rest[2]) | Out-Null }
      { $_ -in 'rm', 'delete' } { Remove-Cmd ([string]$Rest[1]) | Out-Null }
      default        { Write-Host 'Usage: nova cmd [list|add|edit|rm] ...' }
    }
  }
  'cache' {
    Show-Banner
    if ($Rest.Count -and $Rest[0] -eq 'clear') { Clear-Cache } else { Write-Host 'Usage: nova cache clear' }
  }
  'hook' { Show-Banner; Install-Hooks; Write-Ok 'Hooks installed. Open a new cmd window.' }
  'doctor' { Show-Doctor }
  default { Show-Banner; Show-Usage }
}
