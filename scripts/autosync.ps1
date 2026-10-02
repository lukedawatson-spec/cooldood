# Keeps this folder in sync with GitHub (Windows).
#   - Commits and pushes anything you change locally.
#   - Pulls anything changed in the cloud (e.g. by Claude).
# Rojo (`rojo serve`) then pushes the updated files into Roblox Studio live.
#
# Run: double-click scripts\autosync.cmd, or
#      powershell -ExecutionPolicy Bypass -File scripts\autosync.ps1 [-Interval 15]
param([int]$Interval = 15)

Set-Location (Split-Path $PSScriptRoot -Parent)
$branch = (git rev-parse --abbrev-ref HEAD).Trim()
Write-Host "Auto-syncing branch '$branch' with GitHub every $Interval seconds. Press Ctrl+C to stop."

while ($true) {
    if (git status --porcelain) {
        git add -A
        git commit -q -m "Local edits (autosync)"
        Write-Host "$(Get-Date -Format T)  committed local edits"
    }

    $before = (git rev-parse HEAD).Trim()
    git pull -q --rebase origin $branch 2>$null
    if ($LASTEXITCODE -ne 0) {
        if ((Test-Path .git/rebase-merge) -or (Test-Path .git/rebase-apply)) {
            git rebase --abort
            Write-Host "CONFLICT: the same lines were changed locally and in the cloud." -ForegroundColor Red
            Write-Host "Your local commit is kept. Resolve with 'git pull --rebase origin $branch', then restart this script." -ForegroundColor Red
            exit 1
        }
        Write-Host "$(Get-Date -Format T)  couldn't reach GitHub, will retry" -ForegroundColor Yellow
    } elseif ((git rev-parse HEAD).Trim() -ne $before) {
        Write-Host "$(Get-Date -Format T)  pulled cloud changes" -ForegroundColor Green
    }

    $ahead = git rev-list --count "origin/$branch..HEAD" 2>$null
    if ($LASTEXITCODE -eq 0 -and [int]$ahead -gt 0) {
        git push -q origin $branch
        if ($LASTEXITCODE -eq 0) { Write-Host "$(Get-Date -Format T)  pushed to GitHub" -ForegroundColor Green }
    }

    Start-Sleep -Seconds $Interval
}
