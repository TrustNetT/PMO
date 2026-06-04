# PMO - Project Management Office Framework

**A flexible, model-agnostic Project Management Office for coordinating software projects with GitHub Copilot and LLM integration.**

---

## What is PMO?

The PMO framework provides:

- **Dual-repository architecture** — Separate WIP (development) and public (distribution) repos
- **Copilot integration** — Intelligent coding agent guidance optimized for your workflow
- **Model flexibility** — Support for multiple LLM providers (Claude, GPT, Gemini, etc.)
- **Project coordination** — Multi-project tracking, documentation, and CI/CD patterns
- **Community-ready** — Shareable configurations and templates for teams

## Quick Start

For installation and setup instructions, see [docs/guides/](docs/guides/).

## Configuration

### Base Configuration (All Models)

See [.github/instructions/](https://github.com/jcgarcia/PMO/tree/main/.github/instructions/) for core PMO guidance that works with any Copilot-compatible model.

### Model-Specific Optimization

PMO supports optimized configurations for different LLM providers:

**Available Configurations**:
- **claude/** — Optimized for Claude Haiku 4.5, Claude 3.5 Sonnet
- **gpt/** — Optimized for GPT-4, GPT-4 Turbo (coming soon)
- **gemini/** — Optimized for Google Gemini (coming soon)
- **other-models/** — Template for any LLM

**Installation**:

1. Clone or download this PMO repository
2. Choose your preferred model configuration
3. Copy model-specific files to your local `.claude/`, `.gpt/`, etc.
4. See [.github/model-configs/README.md](https://github.com/jcgarcia/PMO/tree/main/.github/model-configs/) for detailed setup

**Example** (Claude):
```bash
# Copy Claude configuration to your home directory
cp -r .github/model-configs/claude/* ~/.claude/
```

## Directory Structure

```
├── .github/
│   ├── instructions/              # Core PMO guidance (all models)
│   └── model-configs/             # Model-specific optimizations
│       ├── claude/                # Claude configuration
│       ├── gpt/                   # GPT configuration (template)
│       ├── other-models/          # Generic template
│       └── README.md              # How to use model configs
├── docs/
│   ├── CRITICAL_WORKFLOW_PATTERN.md
│   ├── DUAL_REPO_SCRIPTS.md
│   └── guides/                    # Installation & setup guides
├── activity/                      # Activity tracking (per session)
└── README.md                      # This file
```

## Key Features

### 1. Model-Agnostic Base Rules

The PMO foundation works with **any Copilot-compatible LLM**:
- Architecture principles
- Workflow patterns
- Safety rules and constraints
- Project structure guidelines

See: `~/.github/copilot-instructions.md`

### 2. Model-Specific Optimizations

Enhance base rules with specific model strengths:
- **Claude**: Extended thinking, long-context processing, structured output
- **GPT**: Function calling, vision capabilities, faster inference
- **Gemini**: Multimodal processing, real-time integration (when available)

See: `~/.github/model-configs/{model}/`

### 3. Flexible Switching

Switch between models without breaking your workflow:
- Base rules remain constant
- Model-specific configs are optional
- Easy to add new models

### 4. Community Templates

Share your optimizations and best practices:
- Submit model configurations to the PMO repo
- Contribute templates for new LLMs
- Help others optimize for their preferred model

## Documentation

### Getting Started
- [Installation Guide](docs/guides/)
- [Dual Repository Workflow](docs/DUAL_REPO_SCRIPTS.md)
- [Critical Workflow Pattern](docs/CRITICAL_WORKFLOW_PATTERN.md)

### Model Configuration
- [How to Use Model-Specific Configs](https://github.com/jcgarcia/PMO/blob/main/.github/model-configs/README.md)
- Claude Configuration Setup (see `.github/model-configs/claude/`)
- Other Models Template (see `.github/model-configs/other-models/`)

### Advanced
- [PMO Architecture Overview](https://github.com/jcgarcia/PMO/wiki/Architecture) (Wiki)
- [Customization Guide](https://github.com/jcgarcia/PMO/wiki/Customization)
- [Contributing Model Configs](https://github.com/jcgarcia/PMO/wiki/Contributing)

## Getting Started

1. **Clone this repository**:
   ```bash
   git clone https://github.com/jcgarcia/PMO.git
   cd PMO
   ```

2. **Choose a configuration**:
   - Review `~/.github/` for base instructions (all models)
   - Select your LLM from `.github/model-configs/`

3. **Install to your environment**:
   - For Claude: `cp -r .github/model-configs/claude/* ~/.claude/`
   - For other models: Adapt using template in `.github/model-configs/other-models/`

4. **Start tracking your work**:
   - Create session in `activity/` directory
   - Follow the workflow patterns in documentation

## Version

Current Version: See [VERSION](VERSION) file

## License

[License information - customize as needed]

## Contributing

Contributions welcome! Please see [CONTRIBUTING.md](https://github.com/jcgarcia/PMO/blob/main/CONTRIBUTING.md) for guidelines.

## Support

- **Documentation**: See `docs/` folder
- **Issues**: GitHub Issues tracker
- **Discussions**: GitHub Discussions

---

**Last Updated**: April 2, 2026  
**Framework**: PMO v2.2 with Model-Specific Configuration Support
