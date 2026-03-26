#Requires -Version 5.0
<#
.SYNOPSIS
    Install Gentleman.Dots configuration on Windows via Scoop
    
.DESCRIPTION
    This script installs the Gentleman.Dots configuration for Windows
    using Scoop package manager. Tools are installed from Scoop's
    main and extras buckets.
    
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

$REPO_URL = "https://github.com/SamuelCastrillon/gentleman-dots-windows"
$CONFIG_DIR = "$env:LOCALAPPDATA\nvim"

# Tools from Scoop main bucket
$MAIN_TOOLS = @(
    "nvim",        # Neovim - Modern terminal text editor
    "nodejs-lts",  # Node.js LTS - JavaScript runtime
    "fd",          # fd - Fast alternative to find
    "ripgrep",     # ripgrep - Fast alternative to grep
    "fzf"          # fzf - Fuzzy finder
)

# Tools from Scoop extras bucket
$EXTRAS_TOOLS = @(
    "lazygit"      # LazyGit - Terminal UI for Git
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

function Test-ScoopBucketExists {
    param([string]$BucketName)
    $buckets = scoop bucket list 2>&1
    return $buckets -match $BucketName
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

# Add main bucket if not exists
Write-Info "Ensuring 'main' bucket exists..."
if (-not (Test-ScoopBucketExists "main")) {
    Write-Info "Adding 'main' bucket..."
    $result = scoop bucket add main 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to add main bucket: $result"
        exit 2
    }
    Write-Success "'main' bucket added"
} else {
    Write-Success "'main' bucket already exists"
}

# Add extras bucket if not exists
Write-Info "Ensuring 'extras' bucket exists..."
if (-not (Test-ScoopBucketExists "extras")) {
    Write-Info "Adding 'extras' bucket..."
    $result = scoop bucket add extras 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to add extras bucket: $result"
        exit 2
    }
    Write-Success "'extras' bucket added"
} else {
    Write-Success "'extras' bucket already exists"
}

# Update scoop
Write-Info "Updating Scoop..."
scoop update
if ($LASTEXITCODE -ne 0) {
    Write-Info "Update completed with warnings (this is usually OK)"
}

# Install tools from main bucket
Write-Info "Installing tools from Scoop 'main' bucket..."
$failedTools = @()

foreach ($tool in $MAIN_TOOLS) {
    Write-Info "Installing main/$tool..."
    $installResult = scoop install main/$tool 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "Failed to install $tool`: $installResult"
        $failedTools += $tool
    } else {
        Write-Success "$tool installed"
    }
}

# Install tools from extras bucket
Write-Info "Installing tools from Scoop 'extras' bucket..."
foreach ($tool in $EXTRAS_TOOLS) {
    Write-Info "Installing extras/$tool..."
    $installResult = scoop install extras/$tool 2>&1
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
    Write-Info "You can try installing them individually with: scoop install main/<tool>"
    exit 3
}

# Clone or update Gentleman.Dots config
Write-Info "Setting up Gentleman.Dots configuration..."
if (-not (Test-Path $CONFIG_DIR)) {
    New-Item -ItemType Directory -Path $CONFIG_DIR -Force | Out-Null
}

# Clone the config repo to a temp location and copy
$tempClone = "$env:TEMP\gentleman-dots-temp"
if (Test-Path $tempClone) {
    Remove-Item -Path $tempClone -Recurse -Force
}

Write-Info "Cloning Gentleman.Dots configuration..."
git clone --depth 1 $REPO_URL $tempClone 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Warning "Could not clone config repository. Please manually copy config files from:"
    Write-Host "    $REPO_URL" -ForegroundColor Yellow
} else {
    # Copy config files
    $configSource = "$tempClone\config\nvim"
    if (Test-Path $configSource) {
        Copy-Item -Path "$configSource\*" -Destination $CONFIG_DIR -Force -Recurse
        Write-Success "Gentleman.Dots configuration installed to $CONFIG_DIR"
    }
    
    # Cleanup temp
    Remove-Item -Path $tempClone -Recurse -Force
}

Write-Success "All Gentleman.Dots tools installed successfully!"
exit 0

# Print next steps
Write-Host "`n--- Next Steps ---" -ForegroundColor Yellow
Write-Host "1. Restart your terminal to refresh PATH"
Write-Host "2. Verify installation: ./scripts/verify-gentleman-dots.ps1"
Write-Host "3. Run Neovim: nvim"
Write-Host "`nFor more info, see: $REPO_URL"
