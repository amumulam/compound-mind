# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.5.0] - 2026-03-10

### Added

- **Incremental Update** - Smart update without losing task history
  - Only create missing Cron tasks
  - Preserve existing tasks and their history
  - Show task status (exists/new)

- **Version Migration** - Automated migration between versions
  - `migrations/v1.4.0-to-v1.5.0.sh` script
  - Update health-state.json structure
  - Create observation-reports directory

- **Backup & Rollback** - Safe update with recovery
  - Automatic backup before update
  - `backups/YYYY-MM-DD-HHMMSS/` directory
  - `rollback.sh` for recovery

- **Update Log** - Track update history
  - `logs/update.log` records all updates
  - Version, timestamp, status, backup location

- **Plan Enforcement** - Ensure plans are documented
  - AGENTS.md checklist for plan creation
  - `compound-mind-plan-check` task (daily 21:00)
  - Alert when long-term tasks missing plan files

### Changed

- **update.sh** - Complete rewrite with incremental update
  - Step 0: Version migration
  - Step 0.5: Automatic backup
  - Step 4: Incremental Cron task update
  - Step 5: Update logging

### Fixed

- Cron tasks being recreated (losing history)
- No backup before update
- No rollback mechanism
- Plans not being documented

---

## [1.4.0] - 2026-03-09

### Added

- **Monitor task** - 5th flywheel task for framework self-monitoring
  - Daily execution at 22:00
  - Check all flywheel task status
  - Check directory structure compliance
  - Check MEMORY.md update status
  - Generate observation report to `life/observation-reports/YYYY-MM-DD.md`
  - Update `life/health-state.json` with current status
- **Observation report generation** - Automated daily report
  - Flywheel task status summary
  - Directory structure check results
  - Content update check results
  - Issues found and optimization suggestions
- **Enhanced health-state.json** - New structure with:
  - `flywheel` - All 5 task statuses
  - `directoryCheck` - Directory structure status
  - `contentCheck` - Content update status
  - `alerts` - Exception alerts

### Changed

- **HEARTBEAT.md redefined** - From "auto-execution guide" to "manual checklist"
  - Clarified: automatic monitoring is done by monitor task
  - Manual checklist for when owner asks about framework status
  - Design documentation for monitor task
- **install.sh** - Added monitor task configuration
- **update.sh** - Added monitor task migration
- **compound-mind.config.json** - Updated to v1.4.0 with tasks list

### Fixed

- Observation reports not being generated
- health-state.json not being updated
- Framework health status not visible

## [1.3.0] - 2026-03-07

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