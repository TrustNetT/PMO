# Critical Workflow Pattern: Permanent vs Temporary Projects

**Date**: March 23, 2026  
**Lesson**: Always distinguish between permanent system files and temporary test projects

## The Architecture

```
~/.PMO/                          ← PERMANENT, system-wide scripts & docs
├── .scripts/
│   ├── newproject              ← Master script (stays here forever)
│   └── ...
├── docs/
│   ├── DUAL_REPO_SCRIPTS.md    ← Master documentation
│   └── guides/
└── .git/                        ← Version controlled

~/GitProjects/PMO.prj/          ← TEMPORARY, test instance
├── pmo-wip/                    ← Testing WIP repo
├── PMO/                        ← Testing public repo
└── (DELETED AND RECREATED on each test)
```

## The Rule

**Permanent files are in `~/.PMO/`**
- System scripts (`newproject`, `publish` templates)
- Documentation (architecture, troubleshooting, patterns)
- Configuration templates
- Golden reference implementations

**Temporary files are in `~/GitProjects/{PROJECT}.prj/`**
- Testing instances of projects
- Per-project generated scripts (like `publish-pmo`)
- Development activity
- Can be safely deleted and recreated

## The Pattern

### ❌ WRONG (loses work)
```bash
# Test in temporary location
~/.PMO/.scripts/newproject -n PMO -t nodejs -o TrustNetT
cd ~/GitProjects/PMO.prj/pmo-wip

# Make improvements to scripts
# Edit tools/publish-pmo, docs, etc.

# Delete everything (testing cycle)
rm -rf ~/GitProjects/PMO.prj ~/wip/priv/pmo-wip ~/wip/pub/PMO

# ❌ ALL IMPROVEMENTS LOST FOREVER
```

### ✅ CORRECT (preserves work)
```bash
# Test in temporary location
~/.PMO/.scripts/newproject -n PMO -t nodejs -o TrustNetT
cd ~/GitProjects/PMO.prj/pmo-wip

# Make improvements to scripts
# Edit tools/publish-pmo, improve documentation

# SAVE improvements BEFORE deleting
cp ~/GitProjects/PMO.prj/pmo-wip/tools/publish-pmo ~/.PMO/docs/
cp ~/GitProjects/PMO.prj/pmo-wip/activity/vibe/ai-instructions.md ~/.PMO/docs/
cd ~/.PMO && git add . && git commit -m "Update: ..."

# Now safely delete test project
rm -rf ~/GitProjects/PMO.prj ~/wip/priv/pmo-wip ~/wip/pub/PMO

# ✅ IMPROVEMENTS PRESERVED in ~/.PMO
```

## File Classification

### Always save to ~/.PMO/
- Scripts (`.scripts/`)
- Templates (`docs/`, `docs/templates/`)
- Master documentation
- Reference implementations
- Configuration examples

### Safe to delete from ~/GitProjects/{PROJECT}.prj/
- Per-project git repos (auto-recreated by newproject)
- Generated activity folders
- Test data
- Temporary files

## Quick Checklist

Before deleting test project repos, ask:
- [ ] Did I improve any scripts? → Copy to `~/.PMO/.scripts/`
- [ ] Did I write important docs? → Copy to `~/.PMO/docs/`
- [ ] Did I find patterns worth keeping? → Document in `~/.PMO/docs/`
- [ ] Did I commit changes to `~/.PMO/`? → `git -C ~/.PMO add . && git commit`

## Git Integration

`~/.PMO` itself is now version-controlled:
```bash
cd ~/.PMO
git log --oneline                 # See all improvements
git show <commit>                 # Review specific changes
git diff HEAD~1                   # What changed last commit
```

This ensures no work is ever lost, even if files are accidentally deleted.

## Example: Saving Improvements

```bash
# You improve the publish script during testing
nano ~/GitProjects/PMO.prj/pmo-wip/tools/publish-pmo
# ↓ Make fixes, test, verify it works

# Save to permanent location BEFORE deleting test repo
cp ~/GitProjects/PMO.prj/pmo-wip/tools/publish-pmo ~/.PMO/docs/publish-script-template.bash

# Save to git
cd ~/.PMO
git add docs/publish-script-template.bash
git commit -m "Fix: Improved path portability in publish script"

# Now safe to delete test project
rm -rf ~/GitProjects/PMO.prj

# Next test cycle uses improved script
~/.PMO/.scripts/newproject -n PMO -t nodejs -o TrustNetT
# ↑ Will include the publish script improvements automatically
```

---

## This Lesson Applied

**March 23, 2026**: Found during PMO script testing
- Tested `newproject` and `publish-{name}` scripts
- Found issues: hardcoded paths, working pattern violations
- Fixed all issues in test versions
- **Saved improvements** to `~/.PMO/docs/DUAL_REPO_SCRIPTS.md`
- **Committed** all changes to `~/.PMO/.git`
- Test project can now be safely deleted
- Next projects will benefit from these improvements

