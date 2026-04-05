# Contributing to Superstar Team

## How to Contribute

### Reporting Issues
- Open a GitHub issue with a clear title
- Include: what you expected, what happened, steps to reproduce
- If it's a `/team` run issue: include the project type, phase where it failed, and error message

### Suggesting Improvements
- Open an issue with the `enhancement` label
- Describe the problem you're solving, not just the solution you want
- Agent prompt improvements are especially welcome — include before/after examples

### Pull Requests

1. Fork the repo
2. Create a branch: `git checkout -b feat/your-feature`
3. Make your changes
4. Run CI checks locally:
   ```bash
   shellcheck -s bash install.sh update.sh
   bash -n install.sh
   bash -n update.sh
   ```
5. Commit with conventional format: `feat:`, `fix:`, `docs:`
6. Open a PR against `main`

### What We're Looking For
- **Agent prompt improvements** — better rules, more specific patterns, fewer false positives
- **Design rules** — new anti-patterns to add to FRONTEND-DESIGN-RULES.md
- **Bug reports** — especially from real `/team` runs with reproduction steps
- **Translations** — README in other languages
- **Real-world examples** — screenshots/recordings of projects built with `/team`

### What We're NOT Looking For
- Converting the system to a different orchestration framework (this is Claude Code native by design)
- Removing the model parameter requirement from Agent tool calls
- Removing safety limits (they exist for good reasons)

## Code Style
- Shell scripts: must pass `shellcheck -s bash`
- Agent .md files: must have frontmatter with `description`, `tools`, `model` fields
- All numeric limits (package count, file count) must be consistent across all files
- CI enforces these automatically

## License
By contributing, you agree that your contributions will be licensed under the Apache 2.0 License.
