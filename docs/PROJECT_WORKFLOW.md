# Project Workflow & Repository Structure

## Overview

Every project uses a **dual-repository pattern** with strict separation between private development (WIP) and public distribution (public repo). This ensures version control for distribution content while keeping the latest working version clean in the public repo.

## Directory Structure Pattern

Every project in `~/GitProjects/{ProjectName}.prj/` follows this symlink structure:

```
~/GitProjects/{ProjectName}.prj/
├── {project-name}-wip    → /home/jcgarcia/wip/priv/{project-name}-wip/  [WIP - SOURCE OF TRUTH]
└── {ProjectName}         → /home/jcgarcia/wip/pub/{ProjectName}/        [PUBLIC - READ ONLY]
```

### Example: PMO Project

```
~/GitProjects/PMO.prj/
├── pmo-wip   → /home/jcgarcia/wip/priv/pmo-wip/    [Work here]
└── PMO       → /home/jcgarcia/wip/pub/PMO/         [Published only]
```

### Example: TrustNet Project (Multiple Components)

```
~/GitProjects/TrustNet.prj/
├── trustnet-wip         → /home/jcgarcia/wip/priv/trustnet-wip/
├── android-app-wip      → /home/jcgarcia/wip/priv/android-app-wip/
├── ios-app-wip          → /home/jcgarcia/wip/priv/ios-app-wip/
├── TrustNet             → /home/jcgarcia/wip/pub/TrustNet/
├── android-app          → /home/jcgarcia/wip/pub/android-app/
└── ios-app              → /home/jcgarcia/wip/pub/ios-app/
```

## The Golden Rule: NEVER Work in ~/wip/

- ❌ **NEVER** `cd ~/wip/priv/` or `cd ~/wip/pub/`
- ❌ **NEVER** `cd /home/jcgarcia/wip/`
- ✅ **ALWAYS** work in `~/GitProjects/` using symlinks only
- ✅ **ALWAYS** edit in `-wip` repos (private development)
- ✅ **NEVER** commit or push in public repos directly

**Correct:**
```bash
cd ~/GitProjects/PMO.prj/pmo-wip
git add .
git commit -m "message"
git push
```

**Wrong:**
```bash
cd ~/wip/priv/pmo-wip        # ← FORBIDDEN
cd /home/jcgarcia/wip        # ← FORBIDDEN
```

## WIP Folder Structure (by Component)

Each `-wip` repo contains a folder for **each distribution component**. For PMO:

```
~/GitProjects/PMO.prj/pmo-wip/
├── PMO/                          ← PUBLIC DISTRIBUTION FOLDER (version controlled)
│   ├── docs/                     ← Public user docs to distribute
│   ├── .github/instructions/     ← Public workflow rules and instructions
│   ├── README.md                 ← Public user-facing README
│   └── (other public files)
├── docs/                         ← PRIVATE WIP reference docs only
├── activity/                     ← Development tracking (not published)
├── tools/
│   └── publish-pmo              ← Script copies pmo-wip/PMO/* → ~/wip/pub/PMO/
├── .github/
└── README.md                     ← WIP development README
```

## Publishing Workflow

### Step 1: Develop & Commit in WIP

Edit files in `~/GitProjects/{project}-wip/{component}/`:
- Make changes to distribution content in the `{Component}/` folder
- Keep private docs/notes in separate `docs/` and `activity/` folders
- Commit changes in the WIP repo

```bash
cd ~/GitProjects/PMO.prj/pmo-wip
# Edit PMO/README.md, PMO/docs/*, etc.
git add PMO/
git commit -m "Docs: Updated README with new information"
git push
```

### Step 2: Publish to Public Repo

Run the publish script from your project directory:

```bash
cd ~/GitProjects/PMO.prj/pmo-wip
./tools/publish-pmo
```

The script:
1. Reads from `pmo-wip/PMO/` (your source of truth)
2. Clears the public repo (keeps .git)
3. Copies content from `pmo-wip/PMO/` → `~/wip/pub/PMO/`
4. Commits and pushes to GitHub

### Step 3: Verify on GitHub

The public repo now reflects your latest distribution content. End-users see this version.

## Why This Structure?

| Aspect | Benefit |
|--------|---------|
| **WIP contains distribution folder** | Version control for what gets distributed |
| **Public repo stays clean** | Only latest working version, no history clutter |
| **Publish script automates sync** | No manual copying or manual commits in public |
| **Never edit public directly** | Prevents accidental inconsistencies |
| **All work in ~GitProjects** | Clear separation from physical ~/wip directories |

## Multiple Components Example: TrustNet

Each component has its own WIP and publish script:

```
TrustNet.prj/trustnet-wip/
├── TrustNet/                 ← Main app distribution content
├── docs/                     ← Private docs

TrustNet.prj/android-app-wip/
├── android-app/              ← Android app distribution content
├── docs/                     ← Private docs

TrustNet.prj/ios-app-wip/
├── ios-app/                  ← iOS app distribution content
├── docs/                     ← Private docs
```

Each publishes independently with its own `./tools/publish-{component}` script.

## Best Practices

1. **Organize by component**: One folder per distribution target
2. **Version control distribution content**: Commit `{component}/` folder changes
3. **Keep private notes separate**: Use `docs/` and `activity/` for WIP-only content
4. **Use publish script**: Never manually copy or commit in public repos
5. **Only commit in WIP**: All git operations happen in `-wip` repos
6. **Always use symlinks**: Work exclusively in `~/GitProjects/`

## Troubleshooting

**Q: I edited the public repo by mistake. What do I do?**  
A: Don't worry. Run `./tools/publish-pmo` which will overwrite it with the correct content from WIP. Never manually fix the public repo.

**Q: Which repo is the "source of truth"?**  
A: The WIP repo is the source of truth. The public repo is always generated from WIP.

**Q: Can I commit in the public repo?**  
A: No. Public repos only receive commits from the publish script. Manual commits will be overwritten on the next publish.

**Q: Why not just have one repo?**  
A: The dual structure allows version control for distribution content (WIP) while keeping public repos clean and focused on end-users (latest version only).
