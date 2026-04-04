# Disclaimer & Legal Notice

## No Warranty

SUPERSTAR TEAM is provided "as is" without warranty of any kind. The authors are not responsible for any damage, data loss, unexpected charges, or other consequences arising from the use of this software.

## Token Consumption Warning

This tool spawns multiple Claude Opus agents simultaneously. Each agent consumes tokens independently. A single `/team` run can consume 5-10x the tokens of a normal Claude Code session. **Monitor your usage.** The authors are not responsible for unexpected API charges or quota exhaustion.

Estimated costs per `/team` run:
- Small feature: $3-8
- Medium feature: $8-20
- Large feature: $20-50+

## AI-Generated Code

All code produced by SUPERSTAR TEAM agents is AI-generated. While the pipeline includes automated code review, security scanning, and testing, **AI-generated code may contain bugs, security vulnerabilities, or logical errors.** You are responsible for reviewing and validating all output before deploying to production.

## Third-Party Skills

This tool installs skills from third-party repositories:
- [obra/superpowers](https://github.com/obra/superpowers) — MIT License
- [planetscale/database-skills](https://github.com/planetscale/database-skills) — MIT License
- [addyosmani/web-quality-skills](https://github.com/addyosmani/web-quality-skills) — MIT License
- [trailofbits/skills](https://github.com/trailofbits/skills) — CC-BY-SA-4.0 License
- [EveryInc/compound-engineering-plugin](https://github.com/EveryInc/compound-engineering-plugin) — MIT License
- [coleam00/excalidraw-diagram-skill](https://github.com/coleam00/excalidraw-diagram-skill) — MIT License
- [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills) — MIT License

These are cloned from GitHub at install time. The authors of SUPERSTAR TEAM do not control or guarantee the content, security, or availability of these repositories. Review their licenses before commercial use.

## Data Collection

SUPERSTAR TEAM stores knowledge files locally at `~/.claude/knowledge/`. This data never leaves your machine unless you explicitly push it somewhere. Training data (JSONL format) is stored locally for your own future use.

## Not Affiliated

SUPERSTAR TEAM is an independent project. It is not affiliated with, endorsed by, or officially associated with Anthropic, OpenAI, Google, Trail of Bits, Vercel, PlanetScale, or any other company whose tools or skills are referenced.

## Responsible Use

This tool is designed for legitimate software development. Do not use it to:
- Generate malicious software
- Bypass security controls
- Produce content that violates applicable laws
- Overwhelm API services or infrastructure

## Limitation of Liability

In no event shall the authors be liable for any direct, indirect, incidental, special, exemplary, or consequential damages (including but not limited to procurement of substitute goods or services, loss of use, data, or profits) arising in any way out of the use of this software.

---

By installing and using SUPERSTAR TEAM, you acknowledge that you have read and understood this disclaimer.
