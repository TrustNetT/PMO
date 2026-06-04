# Template: Creating Configuration for Any LLM

**This template helps you create optimized Copilot configuration for any LLM model.**

Use this guide to add support for GPT, Gemini, Llama, or any other LLM to PMO.

---

## Overview

Each model-specific configuration follows this structure:

```
~/{model}/
├── README.md                   # Installation & quick start (this file)
├── {model}-instructions.md     # Model-specific rules (main file)
├── model-config.md             # Capabilities/constraints reference
└── skills/
    ├── {capability-1}.md       # Specialized patterns
    ├── {capability-2}.md
    └── {capability-3}.md
```

---

## Step-by-Step Guide

### Step 1: Understand Your Model

**Gather Information**:

- What's the model name and version?
- What's the context window size?
- What are the key strengths?
- What are the limitations?
- What unique features exist?

**Example (Claude)**:
- Name: Claude Haiku 4.5
- Context: 100K tokens
- Strengths: Extended thinking, JSON mode, long documents
- Limits: No real-time internet
- Features: Vision (Sonnet only), artifacts, structured output

**Example (GPT)**:
- Name: GPT-4 Turbo
- Context: 128K tokens
- Strengths: Function calling, vision, real-time knowledge
- Limits: Expensive, slower than Haiku
- Features: Image vision, browser access (via plugins)

### Step 2: Create Folder Structure

```bash
# Create directory for your model
mkdir -p ~/{model-name}/skills

# Create files
touch ~/{model-name}/README.md
touch ~/{model-name}/{model-name}-instructions.md
touch ~/{model-name}/model-config.md

# Create skill placeholders
touch ~/{model-name}/skills/{skill-1}.md
touch ~/{model-name}/skills/{skill-2}.md
```

**Example (for GPT)**:
```bash
mkdir -p ~/.gpt/skills
touch ~/.gpt/README.md
touch ~/.gpt/gpt-instructions.md
touch ~/.gpt/model-config.md
touch ~/.gpt/skills/function-calling.md
touch ~/.gpt/skills/vision-analysis.md
```

### Step 3: Write `README.md`

**Contents**:

1. **Title and description** — What this config provides
2. **Quick start** — 5-minute installation
3. **Feature list** — What's included
4. **File descriptions** — What each file does
5. **Installation variants** — Options for partial setup
6. **Troubleshooting** — Common issues
7. **Support** — How to get help

**See `claude/README.md`** for full example.

### Step 4: Write `{model}-instructions.md`

**This is the main configuration file.**

**Structure**:

```markdown
# {Model}-Specific Configuration

## Overview
- About {model}
- How this config helps
- What's included

## Core Principles
- Key rules specific to {model}
- Strengths to leverage
- Limitations to respect

## Feature-Specific Rules

### Feature 1: {Feature Name}
- How to use it
- Best practices
- Examples
- Anti-patterns

### Feature 2: {Feature Name}
- How to use it
- Best practices
- Examples
- Anti-patterns

## Error Handling & Recovery
- Common errors
- How {model} handles them
- Recovery strategies

## Integration with PMO
- How this extends base rules
- Mapping to base concepts
- Where there are differences

## Performance Optimization
- Tips for speed
- Tips for cost
- Tips for quality

## Examples
- Example prompts
- Example workflows
- Example outputs

## Troubleshooting
- Common issues
- Solutions
- When to use base config instead
```

**Size**: 2000-5000 lines (detailed reference)

**Style**: Clear, actionable, specific to this model

**Example source**: `claude/anthropic-instructions.md` (~2500 lines)

### Step 5: Write `model-config.md`

**This is a reference file (not executable rules).**

**Structure**:

```markdown
# {Model} Configuration Reference

## Model Information
- Official name
- Supported versions
- Provider
- Documentation link

## Capabilities Matrix
- (Detailed table/checklist)

## Technical Specifications
- Context window
- Training cutoff
- Response latency
- Cost (if known)

## Feature Availability
- What works
- What doesn't
- What requires variants
- What requires API keys

## Known Limitations
- Hard limits
- Performance issues
- Integration challenges

## Comparison with Other Models
- How it differs from Claude
- How it differs from Gemini
- Unique strengths
- Relative weaknesses

## When to Use This Model
- Best for these tasks
- Avoid for these tasks
- Cost-benefit analysis

## Updates and Deprecation
- Version history
- Breaking changes
- Deprecated features
- Roadmap
```

**Size**: 500-1000 lines (reference only)

**Style**: Technical, factual, objective

**Example source**: `claude/model-config.md` (~400 lines)

### Step 6: Create Skill Files

**Each skill teaches model-specific patterns.**

**Structure per skill**:

```markdown
# {Skill Name}

## Overview
- What is this skill?
- Why is it useful?
- When to use it?

## Best Practices
1. Do this
2. Then that
3. Verify result

## Examples

### Example 1: {Scenario}
[Input and output]

### Example 2: {Scenario}
[Input and output]

## Anti-Patterns
- Don't do this...
- Avoid that...
- Watch out for...

## Troubleshooting
- If X happens, do Y
- If Z fails, try A

## Integration with PMO
- How this relates to base rules
- Where it adds value
- Whether it's optional
```

**Size**: 200-500 lines per skill

**Number**: 3-5 skills per model

**Example sources**: 
- `claude/skills/extended-thinking.md`
- `claude/skills/long-context.md`

---

## Filling in the Template

### Information Gathering

**For your model, answer**:

1. **Unique strengths** — What does this model do better than others?
2. **Key features** — What special capabilities exist?
3. **Limitations** — What can't it do?
4. **Optimal use cases** — What should it be used for?
5. **Cost profile** — Is it cheap, expensive, balanced?
6. **Integration points** — APIs, plugins, special features?
7. **Performance** — Speed, quality, consistency?

### Rule Development

**From model strengths, create rules**:

Example:
> Model strength: "GPT-4 has excellent vision capabilities"
> Rule: "When analyzing visual content, provide the image and use vision mode explicitly"
> Skill: "vision-analysis.md"

Example:
> Model strength: "Claude can process 100K tokens without degradation"
> Rule: "Leverage long context by providing entire relevant codebase"
> Skill: "long-context.md"

### Testing Your Configuration

Before sharing:

1. Create folder with your config
2. Test in your environment
3. Verify no conflicts with base rules
4. Document any issues
5. Try different scenarios
6. Refine based on testing

---

## Naming Conventions

### Model Name Format

Use the official brief name:

- ✅ `claude/` (not `anthropic-claude/` or `claude-haiku/`)
- ✅ `gpt/` (not `openai-gpt/` or `gpt-4/`)
- ✅ `gemini/` (not `google-gemini/` or `vertex-ai/`)
- ✅ `llama/` (not `meta-llama/` or `llamaa/`)

### File Naming

- `{model}-instructions.md` — Model-specific rules
- `model-config.md` — Reference information (standard name across all)
- `{capability}.md` — Skills (descriptive name)

Examples:
- `gpt-instructions.md` ✅
- `gpt-specific-rules.md` ❌ (use standard name)
- `function-calling.md` ✅
- `gpt-function-calling.md` ❌ (skill alone, no prefix)

---

## Distribution

### Before Sharing

- [ ] Configuration tested thoroughly
- [ ] All files present and complete
- [ ] No personal information in files
- [ ] README includes clear installation steps
- [ ] Troubleshooting section covers common issues
- [ ] Examples provided for key features

### How to Share

1. **Create PR** to PMO repo at:
   ```
   github.com/jcgarcia/PMO
   ```

2. **Include in PR**:
   - Link to model documentation
   - Testing results/examples
   - How this differs from other models
   - Known issues or limitations

3. **PMO team will**:
   - Review for quality
   - Test compatibility
   - Suggest improvements
   - Merge if approved

---

## Checklist

Before considering configuration complete:

### Documentation
- [ ] README.md follows template
- [ ] Clear installation instructions
- [ ] Examples provided
- [ ] Troubleshooting populated
- [ ] Links to official docs work

### Main Configuration File
- [ ] `{model}-instructions.md` created
- [ ] 2000+ lines of detailed guidance
- [ ] All major features documented
- [ ] Examples provided
- [ ] Anti-patterns documented

### Reference Configuration
- [ ] `model-config.md` created
- [ ] Capabilities matrix complete
- [ ] Limitations listed
- [ ] Technical specs provided
- [ ] Comparison with other models

### Skills
- [ ] At least 3 skill files created
- [ ] Each skill 200+ lines
- [ ] Examples in each skill
- [ ] Troubleshooting in each skill

### Testing
- [ ] Configuration tested in real environment
- [ ] No conflicts with base rules verified
- [ ] Skills actually work as documented
- [ ] Installation process tested
- [ ] Troubleshooting verified

### Sharing (if distributing)
- [ ] Quality proofreading done
- [ ] No hardcoded paths (use ~/)
- [ ] No personal information
- [ ] Ready for public sharing

---

## Examples to Reference

### Complete Examples

See PMO repo for finished configurations:
- `claude/` — Fully complete example
- `other-models/` — This template

### Timeline

Creation timeline (rough estimates):

- Gather information: 1-2 hours
- Write main instructions: 4-6 hours
- Write model config: 1-2 hours
- Create skills: 2-4 hours
- Test thoroughly: 2-4 hours
- Polish & document: 1-2 hours

**Total**: 10-20 hours for complete configuration

---

## Common Questions

### Q: How detailed should instructions be?

**A**: 2000-5000 words per section. Include:
- What, why, how
- Examples (2+ per feature)
- Anti-patterns (common mistakes)
- Integration with PMO

### Q: Do I need all skills?

**A**: Start with 3-5 most important. Can add more later.

### Q: What if model changes?

**A**: Update `model-config.md` and version the folder

### Q: Can users customize?

**A**: Yes! Document in README.md how to do it

### Q: Should I include benchmarks?

**A**: Optional. If included, be precise about:
- What was tested
- Testing methodology
- Test date
- Model version

---

## Need Help?

- **Questions about PMO**? Check main README.md
- **Model documentation**? Link to official docs
- **Examples**? See `claude/` folder
- **Structure help**? Review this template carefully
- **Feedback**? Create issue in PMO repo

---

**Framework**: PMO v2.2  
**Template Version**: 1.0  
**Status**: Ready for use  
**Last Updated**: April 2, 2026

---

**Next Steps**:
1. Pick your model
2. Gather information (Step 1)
3. Follow the template
4. Test thoroughly
5. Share with community!
