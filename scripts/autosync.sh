#!/usr/bin/env bash
# Keeps this folder in sync with GitHub (macOS / Linux).
#   - Commits and pushes anything you change locally.
#   - Pulls anything changed in the cloud (e.g. by Claude).
# Rojo (`rojo serve`) then pushes the updated files into Roblox Studio live.
#
# Run: ./scripts/autosync.sh [interval-seconds]
interval="${1:-15}"

cd "$(dirname "$0")/.." || exit 1
branch="$(git rev-parse --abbrev-ref HEAD)"
echo "Auto-syncing branch '$branch' with GitHub every ${interval}s. Press Ctrl+C to stop."

while true; do
	if [ -n "$(git status --porcelain)" ]; then
		git add -A
		git commit -q -m "Local edits (autosync)"
		echo "$(date +%T)  committed local edits"
	fi

	before="$(git rev-parse HEAD)"
	if ! git pull -q --rebase origin "$branch" 2>/dev/null; then
		if [ -d .git/rebase-merge ] || [ -d .git/rebase-apply ]; then
			git rebase --abort
			echo "CONFLICT: the same lines were changed locally and in the cloud." >&2
			echo "Your local commit is kept. Resolve with 'git pull --rebase origin $branch', then restart this script." >&2
			exit 1
		fi
		echo "$(date +%T)  couldn't reach GitHub, will retry"
	elif [ "$(git rev-parse HEAD)" != "$before" ]; then
		echo "$(date +%T)  pulled cloud changes"
	fi

	if ahead="$(git rev-list --count "origin/$branch..HEAD" 2>/dev/null)" && [ "$ahead" -gt 0 ]; then
		git push -q origin "$branch" && echo "$(date +%T)  pushed to GitHub"
	fi

	sleep "$interval"
done
