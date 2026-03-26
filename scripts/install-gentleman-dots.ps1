#Requires -Version 5.0
<#
.SYNOPSIS
    Install Gentleman.Dots development tools on Windows via Scoop
    
.DESCRIPTION
    This script installs the complete Gentleman.Dots development stack
    using Scoop package manager on Windows.
    
    Exit Codes:
    0 - Success
    1 - Scoop not installed
    2 - Bucket add failed
    3 - Tool install failed
    
.EXAMPLE
    irm https://raw.githubusercontent.com/SamuelCastrillon/gentleman-dots-windows/main/scripts/install-gentleman-dots.ps1 | iex
#>

[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

$BUCKET_NAME = "gentleman-dots-windows"
$REPO_URL = "https://github.com/SamuelCastrillon/gentleman-dots-windows"
$TOOLS = @(
    "neovim",
    "nodejs-lts",
    "lazygit",
    "fd",
    "ripgrep",
    "fzf"
)

function Write-Success {
    param([string]$Message)
    Write-Host "[SUCCESS] $Message" -ForegroundColor Green
}

function Write-Info {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Cyan
}

function Write-Error {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

# Check if Scoop is installed
Write-Info "Checking for Scoop..."
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Error "Scoop is not installed. Please install Scoop first:"
    Write-Host "    iwr -useb get.scoop.sh | iex" -ForegroundColor Yellow
    exit 1
}
Write-Success "Scoop is installed"

# Check if running as administrator (needed for some installs)
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if ($isAdmin) {
    Write-Info "Running as administrator"
}

# Add the bucket
Write-Info "Adding $BUCKET_NAME bucket..."
$bucketResult = scoop bucket add $BUCKET_NAME $REPO_URL 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to add bucket: $bucketResult"
    exit 2
}
Write-Success "Bucket '$BUCKET_NAME' added successfully"

# Update scoop
Write-Info "Updating Scoop..."
scoop update
if ($LASTEXITCODE -ne 0) {
    Write-Info "Update completed with warnings (this is usually OK)"
}

# Install tools
Write-Info "Installing development tools..."
$failedTools = @()

foreach ($tool in $TOOLS) {
    Write-Info "Installing $tool..."
    $installResult = scoop install $BUCKET_NAME/$tool 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "Failed to install $tool`: $installResult"
        $failedTools += $tool
    } else {
        Write-Success "$tool installed"
    }
}

# Report failures
if ($failedTools.Count -gt 0) {
    Write-Warning "The following tools failed to install: $($failedTools -join ', ')"
    Write-Info "You can try installing them individually with: scoop install $BUCKET_NAME/<tool>"
    exit 3
}

Write-Success "All Gentleman.Dots tools installed successfully!"

# Print next steps
Write-Host "`n--- Next Steps ---" -ForegroundColor Yellow
Write-Host "1. Restart your terminal to refresh PATH"
Write-Host "2. Verify installation: scoop list $BUCKET_NAME"
Write-Host "3. Run verify-gentleman-dots.ps1 to check all tools"
Write-Host "`nFor Neovim config, see: https://github.com/SamuelCastrillon/gentleman-dots-windows"
