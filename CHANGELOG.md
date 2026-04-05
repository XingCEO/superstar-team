# Changelog

All notable changes to this project will be documented in this file.

## [1.2.0] - 2026-04-05

### Added
- **Design-first workflow**: Design pipeline (Phase 2) now runs before architecture (Phase 3)
- **Figma Make integration**: Auto-generates Figma prompts per page, reads back via MCP
- **Anti AI Slop design rules**: 533-line spec with concrete pixel values and anti-patterns
- **Visual self-verification**: Frontend agent must screenshot and check each page before commit
- **Mandatory component library**: shadcn/ui required, no hand-crafting basic components
- **Cross-model review**: Optional Codex second opinion (Phase 6.1.5)
- **Hard tool checks**: tsc, eslint, npm test, npm audit as blockers (Phase 6.5)
- **Performance baseline**: Core Web Vitals tracking (Phase 6.7)
- **Post-deploy canary monitoring**: Console errors, performance regression (Phase 7.3)
- **Dynamic Phase 1 follow-ups**: Questions adapt to 6 project types
- **API contract mechanism**: api-contract.md as single source of truth
- **Knowledge base archival**: 90-day auto-archive, INDEX.md capped at 50 lines
- **Design decision logging**: Phase 8 now captures design choices + Figma feedback
- **Auto-update**: Symlink mode, git pull = instant update
- **update.sh**: One-command upgrade from copy mode to symlink mode
- **Version checking**: /status auto-checks for new versions
- **CI pipeline**: 5 jobs (shellcheck, agent validation, command validation, cross-file consistency, install dry-run)
- **Dependency pinning**: All 7 external skills locked to specific commit hashes
- **Demo screenshots**: Desktop + mobile, English + Chinese
- **Bilingual README**: Full English + Traditional Chinese
- **No emoji rule**: Built-in emoji banned in product UI, SVG icon libraries required

### Changed
- License: MIT -> CC BY-NC 4.0 -> Apache 2.0
- Agent depth rebalanced: architect 83, backend 79, frontend 132, tester 118, security 116
- Package limit: 5 -> 10
- File limit: 10 -> 20
- Quality gates: 7 -> 8 (added hard tool checks)
- install.sh: Heredoc agents -> separate files + symlinks
- Hook filter-output.sh: printf -> jq (fixes JSON injection)

### Fixed
- README unicode corruption (CJK characters rendering as ???)
- Phase numbering inconsistencies after design-first reorder
- frontend.md and tester.md missing api-contract.md in required reads
- API contract change notification missing worktree sync step

## [1.0.0] - 2026-04-04

### Added
- Initial release: 5 Opus agents, 24 skills, 3 commands
- /team, /duo, /status commands
- Git worktree isolation for parallel development
- Three-strike rule for agent failure handling
- Knowledge harvesting with JSONL training data format
