#Requires -Version 5.0
<#
.SYNOPSIS
    Verify Gentleman.Dots tools installation
    
.DESCRIPTION
    This script verifies that all Gentleman.Dots development tools
    are correctly installed and accessible.
    
    Exit Codes:
    0 - All checks passed
    4 - One or more checks failed
    
.EXAMPLE
    irm https://raw.githubusercontent.com/SamuelCastrillon/gentleman-dots-windows/main/scripts/verify-gentleman-dots.ps1 | iex
#>

[CmdletBinding()]
param()

$TOOLS = @{
    "nvim" = @{
        "name" = "Neovim"
        "versionCmd" = "nvim --version"
        "pattern" = "v\d+\.\d+"
    }
    "node" = @{
        "name" = "Node.js"
        "versionCmd" = "node --version"
        "pattern" = "v\d+\.\d+"
    }
    "lazygit" = @{
        "name" = "LazyGit"
        "versionCmd" = "lazygit --version"
        "pattern" = "v\d+\.\d+"
    }
    "fd" = @{
        "name" = "fd"
        "versionCmd" = "fd --version"
        "pattern" = "v\d+\.\d+"
    }
    "rg" = @{
        "name" = "ripgrep"
        "versionCmd" = "rg --version"
        "pattern" = "\d+\.\d+"
    }
    "fzf" = @{
        "name" = "fzf"
        "versionCmd" = "fzf --version"
        "pattern" = "\d+\.\d+"
    }
}

$failedChecks = @()
$passedChecks = @()

function Test-Tool {
    param(
        [string]$Name,
        [string]$VersionCmd,
        [string]$Pattern
    )
    
    try {
        $output = Invoke-Expression $VersionCmd 2>&1
        if ($LASTEXITCODE -eq 0 -and $output -match $Pattern) {
            return @{
                success = $true
                output = $output
                version = $matches[0]
            }
        }
    } catch {
        # Tool not found or error
    }
    
    return @{
        success = $false
        output = $output
        version = $null
    }
}

Write-Host "=== Gentleman.Dots Verification ===" -ForegroundColor Cyan
Write-Host ""

# Check scoop bucket
Write-Host "Checking Scoop bucket..." -NoNewline
if (scoop list | Select-String -Pattern "gentleman-dots-windows" -Quiet) {
    Write-Host " [PASS]" -ForegroundColor Green
    $passedChecks += "Scoop bucket"
} else {
    Write-Host " [FAIL]" -ForegroundColor Red
    $failedChecks += "Scoop bucket"
}

# Check each tool
foreach ($tool in $TOOLS.GetEnumerator()) {
    $name = $tool.Key
    $config = $tool.Value
    
    Write-Host "Checking $($config.name)... " -NoNewline
    
    $result = Test-Tool -Name $config.name -VersionCmd $config.versionCmd -Pattern $config.pattern
    
    if ($result.success) {
        Write-Host "[PASS] ($($result.version))" -ForegroundColor Green
        $passedChecks += $config.name
    } else {
        Write-Host "[FAIL]" -ForegroundColor Red
        $failedChecks += $config.name
    }
}

# Check Windows paths
Write-Host "Checking Windows paths..." -NoNewline
if ($env:USERPROFILE -and $env:APPDATA) {
    Write-Host "[PASS]" -ForegroundColor Green
    $passedChecks += "Windows paths"
} else {
    Write-Host "[FAIL]" -ForegroundColor Red
    $failedChecks += "Windows paths"
}

# Summary
Write-Host ""
Write-Host "=== Summary ===" -ForegroundColor Cyan
Write-Host "Passed: $($passedChecks.Count)"
Write-Host "Failed: $($failedChecks.Count)"

if ($failedChecks.Count -gt 0) {
    Write-Host ""
    Write-Host "Failed checks:" -ForegroundColor Red
    foreach ($check in $failedChecks) {
        Write-Host "  - $check" -ForegroundColor Red
    }
    Write-Host ""
    Write-Host "Run install-gentleman-dots.ps1 to install missing tools." -ForegroundColor Yellow
    exit 4
}

Write-Host ""
Write-Success "All checks passed! Gentleman.Dots is ready to use."
exit 0
