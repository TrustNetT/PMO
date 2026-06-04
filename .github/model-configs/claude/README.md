# Claude Configuration for PMO

**Optimized Copilot configuration for Claude Haiku 4.5 and Claude 3.5 Sonnet models.**

This configuration extends the base PMO framework with Claude-specific patterns, capabilities, and best practices.

---

## Quick Start

### Installation (5 minutes)

```bash
# 1. Download or clone PMO repository
git clone https://github.com/jcgarcia/PMO.git
cd PMO

# 2. Copy Claude configuration to home directory
mkdir -p ~/.claude/skills
cp .github/model-configs/claude/anthropic-instructions.md ~/.claude/
cp .github/model-configs/claude/model-config.md ~/.claude/
cp -r .github/model-configs/claude/skills/* ~/.claude/skills/

# 3. Reload VS Code
# Ctrl+Shift+P → Developer: Reload Window
```

### Verification

```bash
# Verify files installed
ls -la ~/.claude/

# Should show:
# - anthropic-instructions.md
# - model-config.md
# - skills/ (directory)
```

---

## What's in This Configuration

### `anthropic-instructions.md`

**Claude-specific enhancements** that extend base PMO rules.

Includes optimizations for:
- **Extended Thinking** — Claude's step-by-step reasoning
- **Long-Context Processing** — 100K token window handling
- **Structured Output** — JSON/XML generation
- **Vision Capabilities** — Image analysis (Sonnet)
- **Artifact Generation** — Code/document creation
- **Code Reasoning** — Deep analysis patterns

**Type**: Extension (adds to base, doesn't replace)

**Size**: ~2000-3000 lines

### `model-config.md`

**Technical reference** for Claude capabilities and constraints.

Contains:
- Model name and versions
- Context window details (100K tokens)
- Supported capabilities checklist
- Known limitations
- Performance characteristics
- When to use Claude vs other models

**Type**: Reference (not executable, informational)

**Size**: ~300-500 lines

### `skills/` Directory

**Specialized skill files** for Claude-specific patterns.

Example skills:
- `extended-thinking.md` — Use Claude's reasoning
- `long-context.md` — Process large codebases
- `structured-output.md` — Generate JSON/XML
- `tool-integration.md` — Code execution patterns

**Type**: Optional enhancements (auto-loaded by Copilot)

**Purpose**: Teach best practices for specific tasks

---

## Configuration Files Status

### Production-Ready ✅

- `anthropic-instructions.md` — Tested and validated
- `model-config.md` — Complete reference

### In Development 🔄

- `skills/extended-thinking.md` — Coming soon
- `skills/long-context.md` — Coming soon
- `skills/structured-output.md` — Coming soon
- `skills/tool-integration.md` — Coming soon

---

## Architecture

### How Claude Configuration Works

```
Step 1: Base PMO loads
   ~/. github/copilot-instructions.md
   ↓
Step 2: Claude extension loads
   ~/.claude/anthropic-instructions.md
   ↓
Step 3: Claude skills load (auto-discovery)
   ~/.claude/skills/*.md
   ↓
Step 4: Copilot runs with combined rules
   (All rules + constraints active)
```

### Key Principles

1. **Non-breaking**: Claude config extends, never overrides base
2. **Optional**: Works with just base config (optimization is bonus)
3. **Compatible**: All rules work together without conflicts
4. **Flexible**: Easy to customize for your needs

---

## Features

### 1. Extended Thinking

Leverage Claude's reasoning strength:
- Step-by-step problem solving
- Deep analysis of complex issues
- Verification of solutions
- Error detection and recovery

### 2. Long-Context Processing

Handle large codebases and documents:
- 100K token context window
- Process entire projects at once
- Analyze relationships across files
- Understand full architecture

### 3. Structured Output

Generate valid JSON and XML:
- Reliable JSON generation (Claude native)
- Schema validation
- Format specifications
- Error handling

### 4. Vision Capabilities

Analyze images (Sonnet only):
- Screenshot analysis
- Diagram understanding
- UI/UX review
- Visual debugging

### 5. Artifact Generation

Create and modify code/documents:
- Artifact best practices
- Container format specifications
- Preview generation
- Multi-artifact workflows

---

## Model Compatibility

### Supported Versions

| Model | Version | Status | Context | Vision |
|-------|---------|--------|---------|--------|
| Claude | Haiku 4.5 | ✅ Tested | 100K | ❌ No |
| Claude | 3.5 Sonnet | ✅ Tested | 200K | ✅ Yes |
| Claude | 3 Opus | ✅ Tested | 200K | ✅ Yes |
| Claude | 3 Haiku | ⚠️ Legacy | 100K | ❌ No |

**Recommended**: Claude 3.5 Sonnet (best balance of capability and cost)

### Version-Specific Notes

- **Haiku 4.5**: Lightweight, fast, suitable for quick tasks
- **3.5 Sonnet**: Balanced, recommended for most use cases
- **3 Opus**: Most capable, best for complex reasoning
- **3 Haiku**: Older, still works but consider upgrading

---

## Installation Variants

### Variant 1: Standard Installation

Full configuration with all features:

```bash
mkdir -p ~/.claude/skills
cp .github/model-configs/claude/anthropic-instructions.md ~/.claude/
cp .github/model-configs/claude/model-config.md ~/.claude/
cp -r .github/model-configs/claude/skills/* ~/.claude/skills/
```

**Use when**: You want all Claude optimizations

### Variant 2: Minimal Installation

Just base instructions, no skills:

```bash
mkdir -p ~/.claude
cp .github/model-configs/claude/anthropic-instructions.md ~/.claude/
```

**Use when**: You prefer base rules only

### Variant 3: Skills-Only Addition

Add to existing configuration:

```bash
mkdir -p ~/.claude/skills
cp -r .github/model-configs/claude/skills/* ~/.claude/skills/
```

**Use when**: You already have anthropic-instructions.md

---

## Customization

### Adapting for Your Workflow

1. **Review** `anthropic-instructions.md`
2. **Identify** rules that don't match your style
3. **Comment out** unnecessary sections
4. **Add** your own patterns at the end
5. **Test** thoroughly
6. **Document** your changes

### Adding Your Own Skills

Create custom skill files:

```bash
# Create custom skill
cat > ~/.claude/skills/my-pattern.md << 'EOF'
# My Custom Skill

[Your pattern description]

[Examples]

[Best practices]
EOF
```

### Team Customization

For team use:

1. Clone this configuration
2. Create team-specific version
3. Add team patterns and rules
4. Distribute to team members
5. Document team conventions

---

## Troubleshooting

### Configuration Not Loading?

**Check 1**: Files exist
```bash
ls -la ~/.claude/
# Should show anthropic-instructions.md
```

**Check 2**: File permissions
```bash
chmod 644 ~/.claude/*.md
chmod 755 ~/.claude/skills
```

**Check 3**: Reload Copilot
- `Ctrl+Shift+P` → Developer: Reload Window

### Rules Not Applied?

**Check**: vs Code recognizes files
- Open any file
- Ask Copilot: "What rules are active?"
- Should mention Claude-specific configuration

### Model Not Recognized?

**Check**:
1. Verify Claude model in GitHub Copilot settings
2. Check subscription includes selected model
3. Some features need Sonnet (vision, large context)
4. Haiku has smaller context window

---

## Performance Tips

### To Get Best Results

1. **Use Claude 3.5 Sonnet** — Balanced capability and speed
2. **Enable extended thinking** — For complex problems
3. **Leverage long context** — Send entire relevant code
4. **Use artifacts** — For code generation tasks
5. **Chain prompts** — Break complex work into steps

### Cost Optimization

- **Use Haiku 4.5** for simple tasks (cheaper, faster)
- **Use Sonnet** for complex reasoning (better results)
- **Use Opus** only for hardest problems (most expensive)

---

## Updates and Maintenance

### When to Update

- PMO base configuration changes
- Claude model updates
- New skills become available
- Bug fixes or improvements

### How to Update

```bash
# Pull latest PMO
cd ~/path/to/PMO
git pull origin main

# Copy updated configuration
cp .github/model-configs/claude/* ~/.claude/
```

### Checking Your Version

```bash
# View your configuration version (if tracked)
head -5 ~/.claude/anthropic-instructions.md
# Look at Last Updated line
```

---

## FAQ

### Q: Is this for all Claude models?

**A**: Yes, but specifically optimized for Claude Haiku 4.5 and 3.5 Sonnet. Should work with other versions but may not be optimal.

### Q: Do I need these files if I'm not using Claude?

**A**: No. Base PMO (`~/.github/copilot-instructions.md`) works alone. This is optional enhancement.

### Q: Can I use both base + Claude config?

**A**: Yes, that's the intended design! Both load, rules combine (not conflict).

### Q: What if I switch from Claude to GPT?

**A**: 1. Keep base PMO (still works)
2. Remove Claude config: `rm -rf ~/.claude/`
3. Install GPT config: `cp .github/model-configs/gpt/* ~/.gpt/`
4. Update Copilot model setting

### Q: How do I contribute improvements?

**A**: See CONTRIBUTING.md in main PMO repo

---

## Support

- **Questions**: Check main README.md in PMO
- **Issues**: Report on GitHub Issues page
- **Discussions**: Use GitHub Discussions
- **Contributions**: Create pull request

---

**Framework**: PMO v2.2  
**Configuration**: Claude Optimized  
**Status**: ✅ Active and Tested  
**Last Updated**: April 2, 2026

---

**Next**: 
- Review [anthropic-instructions.md](anthropic-instructions.md) for full Claude rules
- Check [model-config.md](model-config.md) for capabilities reference
- Explore [skills/](skills/) for specialized patterns
