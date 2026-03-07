# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.4.0] - 2026-03-07

### Added

- Content compliance check mechanism
  - 📋 Content Types table in AGENTS.md (what content goes where)
  - Check if long-term tasks in MEMORY.md have corresponding plan files in `docs/plans/`
  - Alert when content is written to wrong location
- Workspace architecture audit (once per day)
  - Compare workspace structure with Compound Mind standard architecture
  - Discover content not in standard architecture
  - Suggest moving or deleting redundant content

### Changed

- Changed HEARTBEAT.md content to English for consistency
- Updated install.sh with new Content Types table
- Updated templates/HEARTBEAT.md.tmpl with new checks

## [1.3.0] - 2026-03-07

### Added

- Directory structure enforcement mechanism
  - Added 📁 Directory Structure table in AGENTS.md (MUST READ before creating files)
  - Wrong Location indicators (❌) for common mistakes
  - Rule reminder: "When creating a file, first check AGENTS.md for the correct directory"
- Directory structure detection in HEARTBEAT.md
  - Check for wrong directories: `plans/`, `solutions/`, `brainstorms/`
  - Warning message with correct location mapping
- Marker mechanism for AGENTS.md
  - `<!-- COMPOUND_MIND_START/END -->` markers
  - Safe partial updates without overwriting user content

### Changed

- All scripts (install.sh, update.sh, uninstall.sh) now use marker mechanism
- Consistent behavior across AGENTS.md and HEARTBEAT.md updates

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