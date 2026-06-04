# Claude Model Configuration Reference

**STATUS**: Placeholder - To be completed during Phase 1 testing

**Purpose**: Technical reference for Claude capabilities, limitations, and version-specific information.

**Content to include**:

## Model Information
- Claude Haiku 4.5
- Claude 3.5 Sonnet
- Claude 3 Opus
- Claude 3 Haiku (legacy)

## Capabilities Matrix
- ✅ Extended thinking
- ✅ Long-context (100K-200K tokens)
- ✅ JSON mode
- ✅ Vision (Sonnet/Opus only)
- ✅ Artifact generation
- ❌ Real-time internet
- ❌ Fine-tuning via Copilot

## Technical Specifications
- Context windows
- Training cutoff dates
- Performance characteristics
- Cost estimates (if available)

## Known Limitations
- Vision requires Sonnet variant
- No real-time knowledge
- No model fine-tuning via API
- Token limits per request

## Version Differences
- Haiku: Lightweight, fast
- Sonnet: Balanced, recommended
- Opus: Most capable, slowest

---

**See Also**:
- `anthropic-instructions.md` — Optimization rules
- `skills/` — Specialized patterns
- Root `README.md` — Quick start
