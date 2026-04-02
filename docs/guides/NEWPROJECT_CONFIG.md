# newproject Configuration Guide

## Overview

The `newproject` script creates new PMO projects with dual-repo structure (private WIP + public distribution). Configuration can be managed via:

1. **Configuration file** (`~/.jcscripts`) - Persistent defaults
2. **Environment variables** - Override file settings
3. **Command-line arguments** - Override everything
4. **Interactive setup** - `newproject --config`

## Configuration File

### Location
```
~/.jcscripts
```

### Format
YAML-style configuration. The file can contain other settings and mixing formats is fine.

### PMO Section Example
```yaml
# Organization for private WIP repositories
organization: TrustNetT

# GitHub username (optional)
username: jcgarcia

# Default project type
default_type: nodejs
```

## Configuration Options

### organization (Required)
- **What**: GitHub organization/user where private `-wip` repos are created
- **Type**: String
- **Example**: `organization: TrustNetT`
- **Usage**: `newproject -n MyApp` creates `TrustNetT/myapp-wip` (private)
- **Override**: `newproject -n MyApp -o Ingasti` creates `Ingasti/myapp-wip`

### username (Optional)
- **What**: GitHub username for public repo variations
- **Type**: String (empty string if not used)
- **Example**: `username: jcgarcia`
- **Default**: If not set, uses `organization` value
- **Usage**: Can be used for personal public projects
- **Override**: `newproject -n MyApp -u otheruser`

### default_type (Optional)
- **What**: Default project type when `-t` not specified
- **Type**: String
- **Default**: `nodejs`
- **Options**:
  - `nodejs` - Node.js monorepo (Vite + pnpm)
  - `go` - Go microservice (Chi router)
  - `python` - Python project (pipenv/venv)
  - `monorepo` - Generic monorepo structure
  - `docs` - Documentation project
  - `script` - Single script/utility
  - `docker` - Container-based project
  - `rust` - Rust project
- **Example**: `default_type: go`
- **Override**: `newproject -n MyApp -t python`

## Priority Order (Highest to Lowest)

When values come from multiple sources, this priority applies:

1. **Command-line arguments** (highest)
   ```bash
   newproject -n MyApp -t go -o MyOrg
   ```

2. **Environment variables**
   ```bash
   GITHUB_ORG=MyOrg newproject -n MyApp
   ```

3. **Configuration file** (`~/.jcscripts`)
   ```yaml
   organization: DefaultOrg
   default_type: nodejs
   ```

4. **Script defaults** (lowest)
   - `organization`: TrustNetT
   - `default_type`: nodejs

## Usage Examples

### 1. Basic Usage with Config Defaults
```bash
# With ~/.jcscripts containing:
# organization: TrustNetT
# default_type: nodejs

newproject -n MyApp
# Creates:
#   - GitHub: TrustNetT/myapp-wip (private)
#   - GitHub: TrustNetT/MyApp (public)
#   - Type: nodejs
```

### 2. Override Organization
```bash
newproject -n Blog -o Ingasti
# Creates:
#   - GitHub: Ingasti/blog-wip (private)
#   - GitHub: Ingasti/Blog (public)
#   - Uses default type from config
```

### 3. Override Project Type
```bash
newproject -n MailHub -t go
# Creates:
#   - GitHub: TrustNetT/mailhub-wip (private, from config)
#   - GitHub: TrustNetT/MailHub (public)
#   - Type: go
```

### 4. Full Override
```bash
newproject -n MyService -t python -o CompanyOrg
# All values explicitly set, ignores config
```

### 5. Environment Variable Override
```bash
GITHUB_ORG=OpenSource newproject -n PublicLib
# Creates in OpenSource org, ignores config organization
```

### 6. Multiple Projects with Different Defaults
```bash
# Project A: Private TrustNetT projects (use config defaults)
newproject -n PrivateA

# Project B: Public/Organization projects
newproject -n PublicB -o MyOrg

# Project C: Go service in different organization
newproject -n Service -t go -o DevTeam
```

## Interactive Configuration Setup

### First Time Setup
If running newproject without a config file:

```bash
newproject --config
```

This will:
1. Check for existing `~/.jcscripts`
2. Show current settings
3. Prompt for:
   - GitHub organization
   - GitHub username
   - Default project type
4. Save to `~/.jcscripts`

### Update Existing Configuration
```bash
newproject --config
```

Shows current settings and allows you to:
- Keep existing values (press Enter)
- Update any value
- Save new configuration

### Manual Configuration
Edit `~/.jcscripts` directly:

```bash
vim ~/.jcscripts
# Add or update:
# organization: YourOrg
# username: yourusername
# default_type: go
```

## Environment Variables

These override configuration file settings:

### PMO_ROOT
- **What**: Directory where `.prj` folders are created
- **Default**: `~/GitProjects`
- **Example**: `PMO_ROOT=~/work newproject -n MyApp`

### WIP_PARENT
- **What**: Parent directory for private WIP repos
- **Default**: `~/wip/priv`
- **Example**: `WIP_PARENT=~/dev/private newproject -n MyApp`

### PUB_PARENT
- **What**: Parent directory for public repos
- **Default**: `~/wip/pub`
- **Example**: `PUB_PARENT=~/dev/public newproject -n MyApp`

### GITHUB_ORG
- **What**: Override organization from config
- **Example**: `GITHUB_ORG=MyOrg newproject -n MyApp`

### GITHUB_USER
- **What**: Override username from config
- **Example**: `GITHUB_USER=myuser newproject -n MyApp`

## Example Configuration Files

### Team/Company Setup
```yaml
# ~/.jcscripts
# Company projects - all in company organization

organization: CompanyName
username: ""
default_type: nodejs
```

### Multi-Organization Setup
```yaml
# ~/.jcscripts
# Primary organization, override per-project

organization: PersonalOrg
username: ""
default_type: nodejs

# Override: newproject -n Work -o CompanyOrg
# Override: newproject -n OpenSource -o OpenSourceOrg
```

### Go-Heavy Team
```yaml
# ~/.jcscripts
# Team that primarily uses Go

organization: TeamName
username: ""
default_type: go

# Override for occasional Node projects: newproject -n API -t nodejs
```

## Verification

### Check Current Configuration
```bash
cat ~/.jcscripts
```

### Verify Script Behavior
```bash
# Show what newproject would do (with debug output)
newproject -n TestApp

# Shows:
#   Type: nodejs (from config)
#   GitHub org: TrustNetT (from config)
```

### Test Before Creating
```bash
# Use --local-only to test without GitHub
newproject -n TestApp --local-only

# This creates local repos only, good for testing configuration
```

## Troubleshooting

### "GitHub organization is required"
- **Solution**: Set in config or use `-o` flag
- **Check**: `grep organization ~/.jcscripts`
- **Fix**: `newproject --config` or `newproject -o YourOrg`

### Wrong organization being used
- **Check priority**: command-line (`-o`) > env var > config file
- **Verify**: `newproject -n Test -o CorrectOrg`
- **Or update**: `cp ~/.jcscripts ~/.jcscripts.bak && newproject --config`

### Configuration file not found
- **Create**: `newproject --config` (interactive)
- **Or manually**: `cat ~/.jcscripts` then edit as needed

### Can't find organization
- **Verify**: Can you access the organization on GitHub?
- **Check auth**: `gh auth status`
- **List accessible**: `gh org list`

## Advanced Usage

### Different Configurations for Different Tasks
```bash
# Create team projects
newproject -n TeamApp -o TeamOrg

# Create personal projects
newproject -n PersonalApp

# Create open source projects
PMO_ROOT=~/opensrc GITHUB_ORG=OpenSourceOrg newproject -n LibraryName
```

### Using with Automation
```bash
#!/bin/bash
# create-all-projects.sh

PROJECT_NAMES=("api" "frontend" "worker" "admin")
GITHUB_ORG="MyCompany"

for proj in "${PROJECT_NAMES[@]}"; do
    newproject -n "$proj" -o "$GITHUB_ORG" -t nodejs
done
```

### Switching Organizations
```bash
# Temporarily for this command
GITHUB_ORG=TempOrg newproject -n TemporaryApp

# Permanently update
newproject --config
# Then set: organization: TempOrg
```

## Best Practices

1. **Set sensible defaults** in `~/.jcscripts`
   - Use your primary organization
   - Use your most common project type
   - Leave username empty unless you use it

2. **Use command-line overrides** for exceptions
   ```bash
   newproject -n ProjectName -o DifferentOrg
   ```

3. **Keep backups** of working configs
   ```bash
   cp ~/.jcscripts ~/.jcscripts.bak
   ```

4. **Document team defaults** in project README
   ```markdown
   ## Creating New Projects
   
   Default configuration assumes TrustNetT organization.
   Override with: newproject -n Project -o YourOrg
   ```

5. **Test configuration** before running on CI/CD
   ```bash
   newproject -n TestProject --local-only
   ```

## Related Documentation

- [newproject](../guides/gitproject-usage-guide.md) - Full script reference
- [gitproject](../guides/gitproject-usage-guide.md) - Alternative project creation
- [PMO Structure](../PMO_ARCHITECTURE.md) - Overall architecture
- [Publishing Workflow](../publishing/PUBLISH_WORKFLOW.md) - Publishing explained

## Quick Reference

| Task | Command |
|------|---------|
| Create project (use config) | `newproject -n Projects` |
| Create project (override org) | `newproject -n Projects -o MyOrg` |
| Create project (override type) | `newproject -n Projects -t go` |
| Configure interactively | `newproject --config` |
| View configuration | `cat ~/.jcscripts` |
| Update configuration | `newproject --config` |
| Test without GitHub | `newproject -n Test --local-only` |
| Override all settings | `PMO_ROOT=~/w GITHUB_ORG=Org newproject -n App -t python` |
