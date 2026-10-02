# cooldood

A Roblox game whose code lives in this GitHub repo. Edit it here, in the cloud, or with Claude, and it syncs into Roblox Studio on your computer.

```
Claude / GitHub edits ──► GitHub ──► autosync script (git pull) ──► your folder ──► rojo serve ──► Roblox Studio
```

- **[Rojo](https://rojo.space)** syncs the files in `src/` into Studio live.
- **`scripts/autosync`** keeps your local folder in sync with GitHub. Every 15 seconds it pulls cloud changes and pushes your local ones.

## One-time setup

1. **Install Git:** https://git-scm.com/downloads. Then tell Git who you are:
   ```
   git config --global user.name "Your Name"
   git config --global user.email "you@example.com"
   ```
2. **Clone this repo:**
   ```
   git clone https://github.com/lukedawatson-spec/cooldood.git
   cd cooldood
   ```
3. **Install Rokit** (the Roblox tool manager): https://github.com/rojo-rbx/rokit#installation. Then, inside the repo:
   ```
   rokit install
   ```
   This installs the Rojo version pinned in `rokit.toml`.
4. **Install the Rojo plugin in Studio:**
   ```
   rojo plugin install
   ```
   Restart Studio. A **Rojo** button now appears in the Plugins tab.
5. *(Recommended)* Install **VS Code** and its **Rojo** and **Luau Language Server** extensions for editing locally.

## Every time you work

Open two terminals in the repo folder:

| Terminal 1 | Terminal 2 |
|---|---|
| `rojo serve` | Windows: double-click `scripts\autosync.cmd`<br>Mac/Linux: `./scripts/autosync.sh` |

Then open your place in Roblox Studio and go to **Plugins → Rojo → Connect**.

Now any change that reaches GitHub shows up in Studio within about 15 seconds.

## What lives where

| Folder | Appears in Studio as | Use for |
|---|---|---|
| `src/server/` | `ServerScriptService.Server` | Server scripts |
| `src/client/` | `StarterPlayer.StarterPlayerScripts.Client` | Client scripts |
| `src/shared/` | `ReplicatedStorage.Shared` | ModuleScripts used by both |

File naming:
- `Name.server.luau` creates a `Script`.
- `Name.client.luau` creates a `LocalScript`.
- `Name.luau` creates a `ModuleScript`.
- A folder becomes a `Folder`.

Everything else (Workspace, maps, models, UI built in Studio) is **not** managed by Rojo. It stays in your place file, and you save or publish it from Studio as usual.

## ⚠️ Rules that will save you pain

1. **Don't edit synced scripts inside Studio.** Rojo sync is one-way (files → Studio). Edits made in Studio to anything under `Server`, `Client` or `Shared` are **overwritten** at the next sync and never saved to Git. Edit the `.luau` files instead (VS Code, GitHub, or Claude).
2. **Only `src/` code is synced.** Parts, maps and models you build in Studio stay in the `.rbxl` file and on Roblox. They are not in Git.
3. **Still publish from Studio.** Players get updates only when you publish (**File → Publish to Roblox**), not when files sync.
4. **Conflicts:** if the same lines change locally and in the cloud, autosync stops and tells you. Run `git pull --rebase`, fix the marked lines, `git add` them, run `git rebase --continue`, and then restart autosync.

## Bringing in your existing game's scripts

Pick one:
- **Manual (simplest, safest):** copy each script's source from Studio into a matching `.luau` file in `src/`, then delete the original from Studio once Rojo shows the synced copy working.
- **Automatic:** save your place as `game.rbxl` in this folder and run `rojo syncback --input game.rbxl`. Commit first and review the result, because syncback can create many files.
