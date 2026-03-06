# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.2.1] - 2026-03-06

### Added

- Enhanced `compound-mind-knowledge` task message with clear specifications:
  - Data sources: MEMORY.md, life/decisions/, docs/solutions/, memory/*.md
  - Validation criteria: stale (>30 days), isolated (no refs), duplicate (similar)
  - Output location: life/health-state.json
  - Alert mechanism for critical issues

## [1.2.0] - 2026-03-06

### Added

- Partial update mechanism for HEARTBEAT.md
  - Add `<!-- COMPOUND_MIND_START/END -->` markers
  - Update only marker-wrapped content
  - Preserve user-defined content

### Changed

- Renamed `README_CN.md` to `README_ZH.md` (language code, not country code)
- Removed `work/` directory from documentation (not from original design)

## [1.1.0] - 2026-03-06

### Added

- Health monitoring mechanism
  - Cron task status detection
  - MEMORY.md update detection (24h threshold)
  - Directory structure validation
  - Exception notification in heartbeat

### Changed

- Updated HEARTBEAT.md with framework health check section
- Created `life/health-state.json` for tracking

## [1.0.0] - 2026-03-06

### Added

- Initial release of Compound Mind Framework
- Four flywheel tasks:
  - `compound-mind-checkpoint`: Extract key info every 6h
  - `compound-mind-compound`: Create solutions daily at 04:00
  - `compound-mind-knowledge`: Validate knowledge weekly
  - `compound-mind-optimizer`: System maintenance weekly
- Installation script (`install.sh`) with interactive TUI
- Update script (`update.sh`) with remote version checking
- Uninstall script (`uninstall.sh`) preserving user data
- Bilingual README (English + Chinese)
- Directory structure:
  - `docs/solutions/`, `docs/plans/`, `docs/brainstorms/`
  - `life/decisions/`, `life/motivation/`
  - `memory/`
- Compound Mind Rules in AGENTS.md
- Configuration file: `compound-mind.config.json`

### Security

- User data preservation during uninstall (memory/, MEMORY.md)