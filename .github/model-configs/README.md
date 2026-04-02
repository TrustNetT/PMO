# Model-Specific Configurations

**PMO supports multiple LLM models through model-specific configuration files.**

This directory contains optimized instruction sets and skills for different AI models, while maintaining compatibility with the base PMO framework (`~/.github/copilot-instructions.md`).

---

## Quick Start

### Choose Your Model

**Claude** (Recommended if using Anthropic):
```bash
cp -r claude/* ~/.claude/
```

**Other Models** (GPT, Gemini, etc.):
```bash
# 1. Review the template
cat other-models/README.md

# 2. Adapt for your model
cp -r other-models/* ~/{your-model}/
```

---

## Available Configurations

### Claude

**Status**: ✅ Active

**Versions Supported**:
- Claude Haiku 4.5
- Claude 3.5 Sonnet
- Claude 3 Opus

**Location**: `claude/`

**Features**:
- Extended thinking patterns
- Long-context document processing (100K tokens)
- Structured output (JSON/XML mode)
- Vision capabilities (Sonnet variants)
- Artifact generation
- Code reasoning strategies

**Installation**:
```bash
cp claude/anthropic-instructions.md ~/.claude/
cp -r claude/skills/* ~/.claude/skills/
cp claude/model-config.md ~/.claude/
```

**After Installation**:
- Reload VS Code: `Ctrl+Shift+P` → Developer: Reload Window
- Verify: Copilot should load both base instructions + Claude-specific rules

---

### GPT

**Status**: 🔄 Template Available (Contribute Optimizations!)

**Location**: `gpt/` (when available)

**Steps to Add**:
1. Review `other-models/README.md` for template structure
2. Create `gpt/` folder following template
3. Add GPT-specific optimizations
4. Test thoroughly
5. Share back (see Contributing below)

---

### Gemini

**Status**: 🔄 Template Available (Contribute Optimizations!)

**Location**: `gemini/` (when available)

**Steps to Add**:
1. Review `other-models/README.md` for template structure
2. Create `gemini/` folder following template
3. Add Gemini-specific optimizations
4. Test thoroughly
5. Share back (see Contributing below)

---

### Other Models

**Status**: 📝 Generic Template Available

**Location**: `other-models/`

**Purpose**: Template for implementing configurations for any LLM

**Instructions**: See `other-models/README.md`

---

## Architecture

### Model Independence

All configurations extend the **base PMO framework** (`~/.github/copilot-instructions.md`):

```
Base (All Models)
   ↓
+ Model-Specific Extensions
   ↓
= Full Configuration
```

**Benefits**:
- Switching models doesn't break base rules
- Base PMO rules work with any LLM
- Model-specific configs are optional
- Easy to add new models

### Load Order

When using Claude:

```
1. Load: ~/.github/copilot-instructions.md (base)
2. Load: ~/.claude/anthropic-instructions.md (Claude extensions)
3. Load: ~/.claude/skills/ (Claude patterns)
4. Load: ~/.claude/model-config.md (capabilities/constraints)
```

All rules are combined; none override (unless explicitly marked as override in comment).

---

## What's in Each Configuration

### `anthropic-instructions.md`

Claude-specific guidance that extends base rules:

- Extended thinking patterns (step-by-step reasoning)
- Long-context strategies (processing large codebases)
- Structured output preferences (JSON, XML)
- Vision capabilities (image analysis)
- Artifact generation rules
- Token efficiency tips
- Error recovery patterns
- Code reasoning strategies

### `model-config.md`

Reference information about capabilities and constraints:

- Model name and version
- Context window size
- Training data cutoff
- Supported capabilities (✅/❌ checklist)
- Known limitations
- Performance characteristics
- Cost/efficiency notes
- When to use this model
- When to use other models

### `skills/` Directory

Specialized skill files teaching Claude patterns:

- `extended-thinking.md` — How to use Claude's reasoning capabilities
- `long-context.md` — Processing large documents efficiently
- `structured-output.md` — Generating valid JSON/XML
- `tool-integration.md` — Using Claude with code execution

---

## Installation Methods

### Method 1: Fresh Installation

For new environment or user:

```bash
cd ~/Downloads  # or your work directory
git clone https://github.com/jcgarcia/PMO.git
cd PMO

# Install Claude configuration
cp .github/model-configs/claude/anthropic-instructions.md ~/.claude/
cp -r .github/model-configs/claude/skills/ ~/.claude/
cp .github/model-configs/claude/model-config.md ~/.claude/

# Install base PMO configuration
cp .github/instructions/* ~/.github/ 2>/dev/null || echo "Base instructions already exist"
```

### Method 2: Existing PMO Installation

If you already have PMO installed:

```bash
cd ~/GitProjects/PMO  # or wherever you cloned PMO

# Update to latest
git pull origin main

# Install desired model config
cp .github/model-configs/claude/* ~/.claude/
```

### Method 3: Individual Model Switch

Switch between different models:

```bash
# Current: Claude
# Switch to: GPT
cp ~/.claude/active-config.md ~/.claude/backup-claude-config.md
cp .github/model-configs/gpt/* ~/.gpt/
```

---

## Verification

### After Installation

Verify configuration loaded correctly:

```bash
# Check Claude config exists
ls -la ~/.claude/
# Should show: anthropic-instructions.md, model-config.md, skills/

# Check file sizes
du -sh ~/.claude/*
# Should be non-empty

# Verify in VS Code
# - Open any file
# - Ask Copilot: "What is the current configuration?"
# - Should mention both base + Claude-specific rules
```

### Troubleshooting

**Copilot not loading Claude config?**
1. Verify files exist: `ls ~/.claude/`
2. Check file permissions: `chmod 644 ~/.claude/*.md`
3. Reload VS Code: `Ctrl+Shift+P` → Developer: Reload Window
4. Check extension logs: Help → Toggle Developer Tools

**Rules conflicting?**
1. Check for overrides in `anthropic-instructions.md`
2. Ensure no duplicate rule definitions
3. Review model-config.md for constraints
4. Ask Copilot directly: "List all active rules"

**Model capabilities not recognized?**
1. Review `model-config.md` for capability checklist
2. Check Copilot version matches model requirements
3. Some features require model variant (e.g., vision needs Sonnet)
4. Verify subscription includes selected model

---

## Adding New Models

### Process

1. **Create folder** for your model:
   ```bash
   mkdir -p ~/.{model}/skills
   ```

2. **Review template**:
   ```bash
   cat other-models/README.md
   ```

3. **Adapt based on model**:
   - Create `{model}-instructions.md` (specific rules)
   - Create `model-config.md` (capabilities)
   - Create `skills/*.md` (patterns)

4. **Test thoroughly**:
   - Verify base rules load
   - Test model-specific patterns
   - Check for conflicts
   - Document any issues

5. **Contribute back**:
   - Create PR to PMO repo
   - Include documentation
   - Share optimizations

---

## Contributing Model Configurations

**We welcome contributions!**

### How to Contribute

1. **Test your configuration** thoroughly in your environment
2. **Document your changes**:
   - What model/version?
   - What optimizations?
   - Any limitations?
   - Testing steps?
3. **Create a pull request** to the PMO repo
4. **Include examples** of how the configuration improves results
5. **Link to any discussions** or rationale

### What We're Looking For

✅ Optimizations based on actual testing
✅ Clear documentation
✅ Examples of improved vs. baseline performance
✅ Compatibility with base PMO rules
✅ Non-breaking changes (model-specific, not base modifications)

### Review Process

- PMO maintainers will review configuration
- Test against PMO projects
- Request clarifications if needed
- Merge once validated

---

## Maintaining Your Configuration

### Regular Updates

**When PMO base rules update**:
- Base config changes should be compatible
- Model-specific extensions should still work
- If conflicts occur, review `model-config.md` constraints

**When your model updates**:
- Test with new model version
- Update `model-config.md` with new capabilities
- Share updates through PR

### Version Tracking

Track which configuration version you're using:

```bash
# In ~/.claude/VERSION (optional)
echo "Claude Haiku 4.5" > ~/.claude/VERSION
echo "PMO Configuration v2.2" >> ~/.claude/VERSION
```

---

## FAQ

### Q: Do I need model-specific configs?

**A**: No. Base PMO (`~/.github/copilot-instructions.md`) works with any model. Model-specific configs are **optional optimizations** for better results with your specific LLM.

### Q: Will switching models break my workflow?

**A**: No. Base rules remain constant. Only model-specific extensions change. Workflow stays the same.

### Q: Can I use multiple models?

**A**: Yes! Install multiple configurations:
```bash
cp -r .github/model-configs/claude/* ~/.claude/
cp -r .github/model-configs/gpt/* ~/.gpt/
```

Switch between them by loading different skill files.

### Q: Are these configs specific to GitHub Copilot?

**A**: No. They're written for any LLM interface (Copilot, API, local models, etc.). They work with any system that can read instruction files.

### Q: What if my model isn't listed?

**A**: Use the `other-models/` template:
1. Review `other-models/README.md`
2. Create your model folder with template structure
3. Adapt patterns for your model
4. Test and share!

### Q: Can I customize these configs for my team?

**A**: Yes! Clone, customize, and use internally:
```bash
# Fork PMO repo
# Modify .github/model-configs/claude/ for your needs
# Use internally or share with community
```

---

## Support

- **Questions?** Check documentation in `docs/`
- **Issues?** Report on GitHub Issues
- **Discussions?** Join GitHub Discussions
- **Contributions?** See CONTRIBUTING.md

---

**Framework**: PMO v2.2  
**Last Updated**: April 2, 2026  
**Status**: Active (Claude tested, others in progress)
