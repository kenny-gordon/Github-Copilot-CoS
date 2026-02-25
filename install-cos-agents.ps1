# Council of the Seven Agent Installer
param([switch]$Insiders)

$ErrorActionPreference = "Stop"

if ($Insiders) {
    $promptsDir = "$env:APPDATA\Code - Insiders\User\prompts"
    $vsVersion = "VS Code Insiders"
} else {
    $promptsDir = "$env:APPDATA\Code\User\prompts"
    $vsVersion = "VS Code"
}

if (-not (Test-Path $promptsDir)) {
    Write-Host "Creating directory: $promptsDir" -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $promptsDir -Force | Out-Null
}

$agents = "Grandmaster.agent.md", "Weaver.agent.md", "Archivist-subagent.agent.md", "Pathbreaker-subagent.agent.md", "Construct-subagent.agent.md", "Artisan-subagent.agent.md", "Arbiter-subagent.agent.md"

Write-Host "`n=== Council of the Seven Installer ===" -ForegroundColor Cyan
Write-Host "Target: $vsVersion" -ForegroundColor Cyan
Write-Host "Directory: $promptsDir`n" -ForegroundColor Cyan

$copied = 0
$failed = 0

foreach ($agent in $agents) {
    $src = Join-Path $PSScriptRoot $agent
    $dst = Join-Path $promptsDir $agent
    
    if (Test-Path $src) {
        Copy-Item $src $dst -Force
        Write-Host "[OK] Installed: $agent" -ForegroundColor Green
        $copied++
    } else {
        Write-Host "[FAIL] Not found: $ agent" -ForegroundColor Red
        $failed++
    }
}

Write-Host "`n=== Summary ===" -ForegroundColor Cyan
Write-Host "Installed: $copied Council member(s)" -ForegroundColor Green
if ($failed -gt 0) { Write-Host "Failed: $failed" -ForegroundColor Red }

Write-Host "`n=== Next Steps ===" -ForegroundColor Cyan
Write-Host "1. Reload $vsVersion (Close and reopen)"
Write-Host "2. Try: @Grandmaster or @Weaver"
Write-Host "3. Read the Council governance model in README.md"

Write-Host "`nInstalled Council members:"
Get-ChildItem $promptsDir -Filter "*.agent.md" | Sort-Object Name | Select-Object -ExpandProperty Name

if ($failed -gt 0) { exit 1 }
