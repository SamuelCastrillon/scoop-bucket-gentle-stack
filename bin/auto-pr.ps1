#!/usr/bin/env pwsh
# auto-pr.ps1 - Automatically create PRs for Scoop bucket updates

param(
    [string]$BucketDir = "bucket",
    [string]$CommitMessage = "Update manifests"
)

$ErrorActionPreference = "Stop"

# Check if git repo
if (-not (Test-Path ".git")) {
    Write-Error "Not a git repository. Run from bucket root."
    exit 1
}

# Check for changes
$status = git status --porcelain
if (-not $status) {
    Write-Host "No changes to commit."
    exit 0
}

# Create update branch
$branchName = "update/$(Get-Date -Format 'yyyyMMdd-HHmmss')"
git checkout -b $branchName

# Stage all changes
git add .

# Commit
git commit -m $CommitMessage

# Push
git push -u origin $branchName

# Create PR
gh pr create --title "[Auto] $CommitMessage" --body "Automated manifest update." --base main

Write-Host "PR created successfully!"
