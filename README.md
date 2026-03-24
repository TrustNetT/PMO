# PMO (Project Management Office)

A **Project Management Office (PMO)** is a centralized documentation and coordination hub for managing software projects. This PMO implementation provides:

- **Architecture & Patterns**: Documented best practices for project structure, deployment, and workflow
- **Activity Tracking**: Structured folders for session notes, sprints, and project milestones
- **Dual-Repository Workflow**: WIP (private development) and Public (distribution) repo pattern
- **Project Scaffolding**: Templates and tools for creating and managing new projects
- **AI Agent Guidance**: Instructions for automating development workflows

## Quick Start

### Installation

If you already have PMO installed, navigate to the install directory. To set up a new instance:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/TrustNetT/PMO/main/install.sh)"
```

This creates: `~/GitProjects/PMO/` with full structure and documentation.

### Available Tools

After installation, PMO scripts are automatically added to your PATH:

- **`pmoproject`** — Create new projects with proper directory structure and configurations
  - Usage: `pmoproject -n ProjectName -t nodejs -o OrgName`
  - See `pmoproject --help` for all options

- **`pmoupdate`** — Check for and update your PMO installation
  - Usage: `pmoupdate --check` (check without installing)
  - Usage: `pmoupdate` (check and install if newer)
  - See `pmoupdate --help` for all options

### Basic Workflow

1. **Create a new project**: `pmoproject -n MyProject -t nodejs -o MyOrg`
2. **Explore documentation**: See the [Documentation Index](#documentation-index) below
3. **Set up your activity tracking**: Create dated folders in `activity/sprints/` for your work
4. **Track progress**: Use activity templates and session notes

### Checking for Updates

After installation, you can check if a newer version of PMO is available:

```bash
# From any directory - checks if GitHub version is newer
curl -s https://raw.githubusercontent.com/TrustNetT/PMO/main/VERSION | \
  grep -v "^$" > /tmp/remote_version && \
  echo "Local: $(cat ~/GitProjects/PMO/VERSION)" && \
  echo "GitHub: $(cat /tmp/remote_version)"
```

**Current version**: See `VERSION` file (or `cat VERSION` from PMO root)

### Updating PMO

If a newer version is available on GitHub:

```bash
# Navigate to PMO directory
cd ~/GitProjects/PMO

# Check for updates
git fetch origin main
git log --oneline -5  # See recent changes

# Update only when safe (always review first)
git pull origin main

# Verify the update
cat VERSION            # Confirm new version
```

**⚠️ Note**: The update mechanism follows GitHub's `main` branch. Always review changes before pulling to avoid conflicts with your local modifications.

## Directory Structure

```text
PMO/
├── docs/                 # Comprehensive documentation
│   ├── PROJECT_WORKFLOW.md # How to work with projects
│   └── guides/          # How-to guides and setup instructions
├── activity/            # Your work tracking (created per session)
│   ├── status/         # Current status snapshots
│   ├── sprints/        # Sprint and session documentation
│   ├── vibe/           # Project guidance and patterns
│   ├── snapshots/      # Historical backups
│   └── planning/       # Future planning
├── .github/
│   └── instructions/   # GitHub integration guides and workflow rules
├── install.sh          # Installation script
└── README.md           # This file
```

## Documentation Index

### Core Concepts & Workflow

- **[Project Workflow & Repository Structure](docs/PROJECT_WORKFLOW.md)** — Understand the dual-repository pattern (WIP private, public distribution), how to organize project components, and the publish workflow

### Using pmoproject

Create new projects using the `pmoproject` command:

```bash
pmoproject -n ProjectName -t nodejs -o OrgName
```

Run `pmoproject --help` for all available options and project types.

### Activity Tracking

Use these structures to organize your work:

- **`activity/status/current-context.md`** — Track current session state and blockers
- **`activity/sprints/YYYY-MM-DD_description.md`** — Document completed work, findings, and next steps
- **`activity/vibe/ai-instructions.md`** — Project-specific guidance for AI agents or future developers
- **`activity/snapshots/`** — Backup old versions before major refactoring

## Getting Help

- Check the [Documentation Index](#documentation-index) for guides matching your task
- Review [.github/instructions/](.github/instructions/) for workflow rules and GitHub integration
- Create activity notes in `activity/sprints/` to track your progress and document solutions
