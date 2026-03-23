# Dual-Repo Project Automation Scripts

**Last Updated**: March 23, 2026  
**Status**: ✅ Tested & Production-Ready

## Overview

Two core scripts implement the PMO dual-repo architecture:
1. **`newproject`** - Creates new projects with WIP + public repos
2. **`publish-{name}`** - Syncs WIP to public distribution repo

Both scripts are fully portable and work for any user/OS with proper path handling.

---

## Script 1: `newproject` 

**Location**: `~/.PMO/.scripts/newproject`  
**Purpose**: Initialize complete dual-repo project structure from scratch

### What It Does

```
1. Create directories:
   - WIP repo:    ~/wip/priv/{name}-wip/
   - Public repo: ~/wip/pub/{NAME}/
   
2. Initialize git in both repositories:
   - WIP: Initial commit with README
   - Public: Initial commit with README
   
3. Create GitHub repositories:
   - {name}-wip (private)
   - {NAME} (public)
   
4. Generate project structure:
   - Symlinks in ~/GitProjects/{NAME}.prj/
   - Activity folders for tracking
   - Copilot instructions
   - Publish script (auto-generated per project)
```

### Critical Safety Feature

**Lines 565-577**: CRITICAL check verifies `.git` exists after `gh repo create`
```bash
if [ ! -d "$PUB_PARENT/$PROJECT_NAME_UPPER/.git" ]; then
    # Re-initialize if missing (gh repo create may have cleaned it)
    git init
    # ... restore git configuration and push
fi
```

This prevents silent failures when `gh repo create --source` reinitializes directories.

### Usage

```bash
# Create PMO project
newproject -n PMO -t nodejs -o TrustNetT

# Create Blog in Ingasti org
newproject -n Blog -t nodejs -o Ingasti

# With custom paths
PMO_ROOT=~/work WIP_PARENT=~/dev/priv PUB_PARENT=~/dev/pub \
  newproject -n MyApp -o MyOrg

# Configure defaults
newproject --config
```

### Configuration

Stored in `~/.jcscripts` (YAML format):
```yaml
organization: TrustNetT
username: jcgarcia
default_type: nodejs
```

---

## Script 2: `publish-{name}` 

**Location**: Auto-generated in `{project}-wip/tools/publish-{name-lower}`  
**Purpose**: One-way sync from WIP (source of truth) to public (distribution)

### What It Does

```
1. Verify WIP repo is clean (all changes committed)

2. Clean public repo directory:
   - Delete all contents EXCEPT .git and .gitignore
   - Preserves git history

3. Copy content from WIP:
   - License file (if exists)
   - docs/ folder
   - .github/instructions/ (Copilot guidelines)
   - Generate user-facing README

4. Create git commit in public repo:
   - Single commit with timestamp
   - Tracks what was synced and when

5. Push to GitHub:
   - Syncs changes to public GitHub repo
```

### Critical Design Decisions

1. **One-way only**: WIP → Public (never public → WIP)
2. **Preserves .git**: Never deletes git history or directory
3. **Exclusive content**: Only copies what end-users need
4. **Excludes**:
   - Private activity tracking
   - Internal development notes
   - .env files, secrets
   - node_modules, build artifacts

### Usage Workflow

```bash
# In WIP repo
cd ~/GitProjects/{PROJECT}.prj/{project}-wip

# Make changes, commit regularly
git add .
git commit -m "Your changes"

# When ready to publish
./tools/publish-{name-lower}

# Verify public repo updated
cd ~/GitProjects/{PROJECT}.prj/{PROJECT}
git log --oneline -3  # Should see publish commit

# Push to GitHub if needed
git push origin main
```

### Output Example

```
✓ Publishing PMO to public distribution repo
  WIP source: ~/GitProjects/PMO.prj/pmo-wip
  PUB dest:   ~/wip/pub/PMO

→ Cleaning public repo directory...
✓ Cleaned public directory
→ Copying LICENSE...
→ Copying operational documentation...
✓ docs/ folder copied
→ Copying generic management instructions...
✓ .github/instructions/ copied
→ Creating empty activity folder structure...
✓ activity/ folder structure created (empty for end-users)
→ Generating README.md...
✓ README.md generated
→ Creating git commit...
✓ Commit created
→ Pushing to GitHub...
✓ Pushed to GitHub

✓ Publish complete!

Public repo contents:
  - LICENSE
  - README.md (user-facing overview)
  - docs/ (operational documentation)
  - .github/instructions/ (management guides)
  - activity/ (empty structure for end-users)

Location: ~/wip/pub/PMO

Next steps:
  cd ~/GitProjects/PMO.prj/PMO
  git push origin main
```

---

## Path Portability

### All paths use environment variables or tilde notation

**Portable patterns** ✅:
```bash
PMO_ROOT="${PMO_ROOT:-$HOME/GitProjects}"
WIP_PARENT="${WIP_PARENT:-$HOME/wip/priv}"
PUB_PARENT="${PUB_PARENT:-$HOME/wip/pub}"

# Display with ~ for user readability
PATH_DISPLAY=$(echo "$PATH" | sed "s|$HOME|~|g")
```

**Anti-pattern** ❌:
```bash
/home/jcgarcia/GitProjects      # WRONG - hardcoded user
WIP_ROOT="/home/jci/wip/priv"   # WRONG - hardcoded paths
```

---

## Working Pattern (CRITICAL)

### Always use symlinks from `~/GitProjects/{PROJECT}.prj/`

**CORRECT** ✅:
```bash
cd ~/GitProjects/PMO.prj/pmo-wip          # Edit WIP here
cd ~/GitProjects/PMO.prj/PMO              # Edit public here
git add .
git commit -m "Changes"
./tools/publish-pmo                       # Publish script
```

**PROHIBITED** ❌:
```bash
cd ~/wip/priv/pmo-wip                     # NEVER directly
cd ~/wip/pub/PMO                          # NEVER directly
rm -rf ~/wip/priv/*                       # NEVER touch here
```

### Why?
- Symlinks provide abstraction layer
- Decouples physical location from working interface
- Allows moving storage without breaking workflows
- Prevents accidental corruption of multiple projects

---

## Testing Results (March 23, 2026)

### ✅ newproject Script
- [x] Creates WIP repository with .git
- [x] Creates public repository with .git
- [x] Creates GitHub repositories (private + public)
- [x] Creates proper symlinks in .prj folder
- [x] Generates activity structure
- [x] Creates Copilot instructions
- [x] Generates publish script
- [x] CRITICAL check prevents .git deletion

### ✅ publish Script
- [x] Cleans public directory (preserves .git)
- [x] Copies docs/ folder
- [x] Copies .github/instructions/
- [x] Creates empty activity/ structure
- [x] Generates user-facing README.md
- [x] Creates proper git commit
- [x] Pushes to GitHub
- [x] All output paths use ~ notation
- [x] No hardcoded absolute paths

### ✅ Integration
- [x] WIP and public repos in sync
- [x] Git history maintained in both repos
- [x] Both repos push to GitHub successfully
- [x] Works with any HOME directory
- [x] Symlink-only workflow enforced

---

## Troubleshooting

### "WIP repository has uncommitted changes"
**Cause**: Trying to publish without committing changes  
**Fix**: `git add . && git commit -m "message"` then try again

### "Public directory not found"
**Cause**: Repos deleted or wrong project name  
**Fix**: Check `PUB_PARENT` environment variable, ensure repos exist

### ".git directory missing after GitHub creation"
**Cause**: Rare issue with `gh repo create --source` reinitializing  
**Fix**: Automatic - newproject's CRITICAL check handles this

### "Git push rejected"
**Cause**: GitHub access issues or auth token expired  
**Fix**: Run `gh auth login` to refresh credentials

---

## Performance Characteristics

- **newproject execution**: ~30-45 seconds (includes GitHub API calls)
- **publish execution**: ~5-10 seconds (depends on repo size)
- **Clone after publish**: ~2-5 seconds (small repos)

---

## Future Improvements

- [ ] Support for monorepo structures
- [ ] Multi-publish (sync multiple projects at once)
- [ ] Rollback mechanism (restore from git history)
- [ ] Scheduled automated publishing
- [ ] Smart conflict detection
- [ ] Publishing to multiple registries

---

## References

- **Architecture**: `~/GitProjects/.PMO/copilot-instructions.md`
- **Examples**: Check `~/GitProjects/{PROJECT}.prj/{project}-wip/activity/`
- **Theory**: Gitproject v2.2 dual-repo pattern

