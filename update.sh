#!/bin/bash

# Compound Mind Framework - Update Script (v1.5.0 - 增量更新)
# Usage: ./update.sh

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

# Defaults
DEFAULT_OPENCLAW_DIR="/root/.openclaw"
OPENCLAW_DIR=""
WORKSPACE=""
AGENT_ID=""
MODEL=""

# Remote repository
REPO_URL="https://github.com/amumulam/compound-mind"
RAW_URL="https://raw.githubusercontent.com/amumulam/compound-mind/main"

# ─────────────────────────────────────────────────────────────────────────────
# Interactive Selection
# ─────────────────────────────────────────────────────────────────────────────

select_option() {
  local options=("$@")
  local selected=0
  local count=${#options[@]}
  
  tput civis
  
  for i in "${!options[@]}"; do
    if [ $i -eq $selected ]; then
      echo -e "  ${CYAN}➜${NC} ${BOLD}${options[$i]}${NC}"
    else
      echo -e "    ${DIM}${options[$i]}${NC}"
    fi
  done
  
  while true; do
    read -rsn1 key
    
    if [[ "$key" == $'\x1b' ]]; then
      read -rsn2 -t 0.1 key
      case "$key" in
        '[A]')
          if [ $selected -gt 0 ]; then
            tput cuu $count
            selected=$((selected - 1))
            for i in "${!options[@]}"; do
              if [ $i -eq $selected ]; then
                echo -e "  ${CYAN}➜${NC} ${BOLD}${options[$i]}${NC}"
              else
                echo -e "    ${DIM}${options[$i]}${NC}"
              fi
            done
          fi
          ;;
        '[B]')
          if [ $selected -lt $((count - 1)) ]; then
            tput cuu $count
            selected=$((selected + 1))
            for i in "${!options[@]}"; do
              if [ $i -eq $selected ]; then
                echo -e "  ${CYAN}➜${NC} ${BOLD}${options[$i]}${NC}"
              else
                echo -e "    ${DIM}${options[$i]}${NC}"
              fi
            done
          fi
          ;;
      esac
    elif [[ "$key" == "" ]]; then
      tput cnorm
      echo ""
      return $selected
    elif [[ "$key" == "k" ]] || [[ "$key" == "K" ]]; then
      if [ $selected -gt 0 ]; then
        tput cuu $count
        selected=$((selected - 1))
        for i in "${!options[@]}"; do
          if [ $i -eq $selected ]; then
            echo -e "  ${CYAN}➜${NC} ${BOLD}${options[$i]}${NC}"
          else
            echo -e "    ${DIM}${options[$i]}${NC}"
          fi
        done
      fi
    elif [[ "$key" == "j" ]] || [[ "$key" == "J" ]]; then
      if [ $selected -lt $((count - 1)) ]; then
        tput cuu $count
        selected=$((selected + 1))
        for i in "${!options[@]}"; do
          if [ $i -eq $selected ]; then
            echo -e "  ${CYAN}➜${NC} ${BOLD}${options[$i]}${NC}"
          else
            echo -e "    ${DIM}${options[$i]}${NC}"
          fi
        done
      fi
    fi
  done
}

# ─────────────────────────────────────────────────────────────────────────────
# Version Check
# ─────────────────────────────────────────────────────────────────────────────

get_local_version() {
  local version_file="$1/compound-mind.config.json"
  if [ -f "$version_file" ]; then
    grep -o '"version": *"[^"]*"' "$version_file" | cut -d'"' -f4
  else
    echo "0.0.0"
  fi
}

get_remote_version() {
  curl -s "${RAW_URL}/compound-mind.config.json" 2>/dev/null | grep -o '"version": *"[^"]*"' | cut -d'"' -f4 || echo "0.0.0"
}

compare_versions() {
  local v1="$1"
  local v2="$2"
  
  if [ "$v1" = "$v2" ]; then
    echo "equal"
    return
  fi
  
  local IFS='.'
  read -ra v1_parts <<< "$v1"
  read -ra v2_parts <<< "$v2"
  
  for i in "${!v1_parts[@]}"; do
    if [ -z "${v2_parts[$i]}" ]; then
      echo "newer"
      return
    fi
    if [ "${v1_parts[$i]}" -gt "${v2_parts[$i]}" ]; then
      echo "newer"
      return
    elif [ "${v1_parts[$i]}" -lt "${v2_parts[$i]}" ]; then
      echo "older"
      return
    fi
  done
  
  echo "equal"
}

# ─────────────────────────────────────────────────────────────────────────────
# Header
# ─────────────────────────────────────────────────────────────────────────────

clear
echo ""
echo -e "  ${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "  ${BOLD}${BLUE}   🔄 Compound Mind Framework Updater (v1.5.0)${NC}"
echo -e "  ${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "  ${DIM}Use ↑↓ to navigate, Enter to select${NC}"
echo ""

# ─────────────────────────────────────────────────────────────────────────────
# Step 1: Select OpenClaw Directory
# ─────────────────────────────────────────────────────────────────────────────

echo -e "  ${BOLD}[Step 1/3]${NC} Select OpenClaw installation directory"
echo ""

OPTIONS=("Default: ${DEFAULT_OPENCLAW_DIR}" "Custom path...")
select_option "${OPTIONS[@]}"
choice=$?

if [ $choice -eq 0 ]; then
  OPENCLAW_DIR="$DEFAULT_OPENCLAW_DIR"
else
  echo ""
  echo -e "  ${YELLOW}Enter OpenClaw installation path:${NC}"
  echo -n "  ➜ "
  read -r OPENCLAW_DIR
  if [ ! -d "$OPENCLAW_DIR" ]; then
    echo -e "  ${RED}✗ Directory not found: ${OPENCLAW_DIR}${NC}"
    exit 1
  fi
fi

echo -e "  ${GREEN}✓ Selected:${NC} ${OPENCLAW_DIR}"
echo ""

# ─────────────────────────────────────────────────────────────────────────────
# Step 2: Select Workspace
# ─────────────────────────────────────────────────────────────────────────────

echo -e "  ${BOLD}[Step 2/3]${NC} Select workspace to update"
echo ""

WORKSPACES=()
while IFS= read -r -d '' dir; do
  WORKSPACES+=("$(basename "$dir")")
done < <(find "$OPENCLAW_DIR" -maxdepth 1 -type d -name "workspace-*" -print0 2>/dev/null | sort -z)

if [ ${#WORKSPACES[@]} -eq 0 ]; then
  echo -e "  ${RED}✗ No workspace directories found${NC}"
  exit 1
fi

select_option "${WORKSPACES[@]}"
workspace_choice=$?

WORKSPACE="${OPENCLAW_DIR}/${WORKSPACES[$workspace_choice]}"
AGENT_ID="${WORKSPACES[$workspace_choice]#workspace-}"

echo -e "  ${GREEN}✓ Selected:${NC} ${WORKSPACES[$workspace_choice]}"
echo -e "  ${DIM}Agent ID:${NC} ${AGENT_ID}"
echo ""

# ─────────────────────────────────────────────────────────────────────────────
# Step 3: Version Check
# ─────────────────────────────────────────────────────────────────────────────

echo -e "  ${BOLD}[Step 3/3]${NC} Checking for updates..."
echo ""

LOCAL_VERSION=$(get_local_version "$WORKSPACE")
REMOTE_VERSION=$(get_remote_version)

echo -e "  ${DIM}Local version:${NC}  ${LOCAL_VERSION}"
echo -e "  ${DIM}Remote version:${NC} ${REMOTE_VERSION}"
echo ""

COMPARE_RESULT=$(compare_versions "$LOCAL_VERSION" "$REMOTE_VERSION")

if [ "$COMPARE_RESULT" = "equal" ]; then
  echo -e "  ${GREEN}✓ Already up to date!${NC}"
  echo ""
  exit 0
elif [ "$COMPARE_RESULT" = "newer" ]; then
  echo -e "  ${YELLOW}⚠ Local version is newer than remote${NC}"
  echo ""
  exit 0
fi

echo -e "  ${GREEN}✓ Update available!${NC}"
echo ""

# Get model from config file first
if [ -f "$WORKSPACE/compound-mind.config.json" ]; then
  CONFIG_MODEL=$(grep -o '"cronModel": *"[^"]*"' "$WORKSPACE/compound-mind.config.json" | cut -d'"' -f4)
  if [ -n "$CONFIG_MODEL" ]; then
    MODEL="$CONFIG_MODEL"
    echo -e "  ${GREEN}✓ Model from config:${NC} ${MODEL}"
  fi
fi

# Fallback: detect from existing Cron tasks
if [ -z "$MODEL" ]; then
  CURRENT_MODEL=$(openclaw cron list --json 2>/dev/null | grep -A5 '"name":"compound-mind-checkpoint"' | grep '"model"' | grep -o '"model":"[^"]*"' | cut -d'"' -f4 | head -1)
  if [ -n "$CURRENT_MODEL" ]; then
    MODEL="$CURRENT_MODEL"
    echo -e "  ${GREEN}✓ Detected model:${NC} ${MODEL}"
  else
    MODEL="bailian-coding-plan/glm-5"
    echo -e "  ${YELLOW}⚠ Using default model:${NC} ${MODEL}"
  fi
fi
echo ""

# ─────────────────────────────────────────────────────────────────────────────
# Confirmation
# ─────────────────────────────────────────────────────────────────────────────

echo -e "  ${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "  ${BOLD}Update Summary${NC}"
echo -e "  ${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "  Workspace: ${GREEN}${WORKSPACES[$workspace_choice]}${NC}"
echo -e "  Agent ID:  ${GREEN}${AGENT_ID}${NC}"
echo -e "  Model:     ${GREEN}${MODEL}${NC}"
echo -e "  Version:   ${YELLOW}${LOCAL_VERSION}${NC} → ${GREEN}${REMOTE_VERSION}${NC}"
echo ""
echo -e "  ${DIM}Will be UPDATED:${NC}"
echo -e "    • Cron tasks payload (incremental update)"
echo -e "    • Directory structure (new directories added)"
echo -e "    • AGENTS.md rules (if new rules available)"
echo -e "    • HEARTBEAT.md (if new checks available)"
echo ""
echo -e "  ${DIM}Will be PRESERVED:${NC}"
echo -e "    • memory/"
echo -e "    • MEMORY.md"
echo -e "    • docs/solutions/"
echo -e "    • life/decisions/"
echo -e "    • life/motivation/"
echo -e "    • Existing Cron tasks and their history"
echo ""
echo -e "  ${YELLOW}Continue with update? (y/n)${NC}"
echo -n "  ➜ "
read -r confirm

if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
  echo -e "  ${YELLOW}Update cancelled${NC}"
  exit 0
fi

echo ""

# ─────────────────────────────────────────────────────────────────────────────
# Update
# ─────────────────────────────────────────────────────────────────────────────

echo -e "  ${BLUE}Updating...${NC}"
echo ""

cd "$WORKSPACE"

# Step 0.5: Create backup
echo -e "  ${DIM}[0.5/4]${NC} Creating backup..."

BACKUP_TIMESTAMP=$(date +%Y%m%d-%H%M%S)
BACKUP_DIR="$WORKSPACE/backups/$BACKUP_TIMESTAMP"
mkdir -p "$BACKUP_DIR"

# Backup key files
cp "$WORKSPACE/compound-mind.config.json" "$BACKUP_DIR/" 2>/dev/null
cp "$WORKSPACE/life/health-state.json" "$BACKUP_DIR/" 2>/dev/null
cp "$WORKSPACE/AGENTS.md" "$BACKUP_DIR/" 2>/dev/null
cp "$WORKSPACE/HEARTBEAT.md" "$BACKUP_DIR/" 2>/dev/null

echo -e "        ${GREEN}✓ Backup created: backups/${BACKUP_TIMESTAMP}${NC}"

# Step 0: Run version migration if needed
echo -e "  ${DIM}[0/4]${NC} Checking for version migration..."

MIGRATION_SCRIPT="$SCRIPT_DIR/migrations/${LOCAL_VERSION}-to-${REMOTE_VERSION}.sh"
if [ -f "$MIGRATION_SCRIPT" ]; then
  echo -e "        ${BLUE}Running migration: ${LOCAL_VERSION} → ${REMOTE_VERSION}${NC}"
  bash "$MIGRATION_SCRIPT" "$WORKSPACE"
  echo -e "        ${GREEN}✓ Migration complete${NC}"
else
  echo -e "        ${DIM}No migration needed${NC}"
fi

# Step 1: Download latest config
echo -e "  ${DIM}[1/4]${NC} Downloading latest version info..."
curl -s "${RAW_URL}/compound-mind.config.json" -o compound-mind.config.json 2>/dev/null
echo -e "        ${GREEN}✓ Done${NC}"

# Step 2: Ensure directory structure exists
echo -e "  ${DIM}[2/4]${NC} Ensuring directory structure..."

mkdir -p docs/solutions
mkdir -p docs/plans
mkdir -p docs/brainstorms
mkdir -p life/decisions
mkdir -p life/motivation
mkdir -p life/observation-reports

[ ! -f "life/motivation/achievements.json" ] && echo '{}' > life/motivation/achievements.json
[ ! -f "life/motivation/milestones.json" ] && echo '{"milestones": [], "nextMilestones": []}' > life/motivation/milestones.json
[ ! -f "life/motivation/streaks.json" ] && echo '{}' > life/motivation/streaks.json

echo -e "        ${GREEN}✓ Done${NC}"

# Step 3: Update AGENTS.md rules (incremental)
echo -e "  ${DIM}[3/4]${NC} Updating AGENTS.md rules (incremental)..."

AGENTS_FILE="$WORKSPACE/AGENTS.md"

if [ -f "$AGENTS_FILE" ]; then
  # Remove old Compound Mind section
  if grep -q "COMPOUND_MIND_START" "$AGENTS_FILE"; then
    sed -i '/<!-- COMPOUND_MIND_START -->/,/<!-- COMPOUND_MIND_END -->/d' "$AGENTS_FILE"
  fi
  
  # Append new Compound Mind section
  cat >> "$AGENTS_FILE" << 'EOF'

---

<!-- COMPOUND_MIND_START -->
## Compound Mind Rules

### 📁 Directory Structure (MUST READ before creating files)

**Before creating any file, check this table first:**

| Content | Correct Location | Wrong Location |
|---------|------------------|----------------|
| Plans | `docs/plans/` | `plans/` ❌ |
| Solutions | `docs/solutions/` | `solutions/` ❌ |
| Brainstorms | `docs/brainstorms/` | `brainstorms/` ❌ |
| Daily logs | `memory/YYYY-MM-DD.md` | Other locations ❌ |

**Rule**: When creating a file, first check AGENTS.md for the correct directory.

### Todo Handling

Do NOT use a standalone todos/ directory.

- **Temporary todos** → Write to `memory/YYYY-MM-DD.md`
- **Long-term/phase todos** → Use `/ce:plan` to create plans in `docs/plans/`

### Directory Structure

| Directory | Purpose |
|-----------|---------|
| `memory/` | Daily logs (permanent) |
| `docs/solutions/` | Solutions (`/ce:compound` output) |
| `docs/plans/` | Plans (`/ce:plan` output) |
| `docs/brainstorms/` | Brainstorms (`/ce:brainstorm` output) |
| `life/decisions/` | Decision logs |
| `life/motivation/` | Achievements/Milestones/Streaks |

### Flywheel Tasks

Automated tasks:

| Task | Schedule | Purpose |
|------|----------|---------|
| Checkpoint Extraction | Every 6h | Extract key info from logs |
| Compound Extraction | Daily 04:00 | Create reusable solutions |
| Knowledge Validation | Sunday 02:30 | Detect stale/conflicts |
| Nighttime Optimizer | Sunday 03:00 | System maintenance |
| Monitor | Daily 22:00 | Framework health monitoring |
<!-- COMPOUND_MIND_END -->
EOF
  echo -e "        ${GREEN}✓ Done${NC}"
fi

# Step 3.5: Update HEARTBEAT.md (incremental)
echo -e "  ${DIM}[3.5/4]${NC} Updating HEARTBEAT.md (incremental)..."

HEARTBEAT_FILE="$WORKSPACE/HEARTBEAT.md"

if [ -f "$HEARTBEAT_FILE" ]; then
  # Remove old Compound Mind section
  if grep -q "COMPOUND_MIND_START" "$HEARTBEAT_FILE"; then
    sed -i '/<!-- COMPOUND_MIND_START -->/,/<!-- COMPOUND_MIND_END -->/d' "$HEARTBEAT_FILE"
  fi
  
  # Append new Compound Mind section
  cat >> "$HEARTBEAT_FILE" << 'EOF'

---

<!-- COMPOUND_MIND_START -->
### Framework Health Check

**Note**: Automatic monitoring is handled by `compound-mind-monitor` task (daily 22:00).

**Manual Checklist** (when owner asks about framework status):

1. **Flywheel Tasks Status**
   - [ ] checkpoint (every 6h)
   - [ ] compound (daily 04:00)
   - [ ] knowledge (Sunday 02:30)
   - [ ] optimizer (Sunday 03:00)
   - [ ] monitor (daily 22:00)

2. **Directory Structure**
   - [ ] docs/solutions/ exists
   - [ ] docs/plans/ exists
   - [ ] docs/brainstorms/ exists
   - [ ] life/decisions/ exists
   - [ ] life/observation-reports/ exists
   - [ ] memory/ exists

3. **Content Updates**
   - [ ] MEMORY.md updated within 24h
   - [ ] Today's log exists
   - [ ] Observation report generated

<!-- COMPOUND_MIND_END -->
EOF
  echo -e "        ${GREEN}✓ Done${NC}"
else
  # File doesn't exist, create from template
  curl -s "${RAW_URL}/templates/HEARTBEAT.md.tmpl" -o "$HEARTBEAT_FILE" 2>/dev/null
  echo -e "        ${GREEN}✓ Created${NC}"
fi

# Step 4: Update Cron tasks (增量更新 - v1.5.0)
echo -e "  ${DIM}[4/4]${NC} Updating Cron tasks (incremental)..."

# 获取现有任务列表
EXISTING_TASKS=$(openclaw cron list --json 2>/dev/null | grep -o '"name":"compound-mind-[^"]*"' | cut -d'"' -f4)

# 检查并创建缺失的任务

# compound-mind-checkpoint
if echo "$EXISTING_TASKS" | grep -q "^compound-mind-checkpoint$"; then
  echo -e "        ${DIM}✓ compound-mind-checkpoint already exists${NC}"
else
  echo -e "        ${BLUE}+ Creating compound-mind-checkpoint${NC}"
  openclaw cron add --name "compound-mind-checkpoint" \
    --every 6h \
    --agent "$AGENT_ID" \
    --model "$MODEL" \
    --message "Checkpoint extraction: Extract key info from today's log. Steps: 1. Read memory/YYYY-MM-DD.md 2. Extract decisions/learnings/events 3. Write to MEMORY.md. If no content, reply CHECKPOINT_OK."
fi

# compound-mind-compound
if echo "$EXISTING_TASKS" | grep -q "^compound-mind-compound$"; then
  echo -e "        ${DIM}✓ compound-mind-compound already exists${NC}"
else
  echo -e "        ${BLUE}+ Creating compound-mind-compound${NC}"
  openclaw cron add --name "compound-mind-compound" \
    --cron "0 4 * * *" \
    --agent "$AGENT_ID" \
    --model "$MODEL" \
    --message "Compound extraction: Extract reusable solutions from logs."
fi

# compound-mind-knowledge
if echo "$EXISTING_TASKS" | grep -q "^compound-mind-knowledge$"; then
  echo -e "        ${DIM}✓ compound-mind-knowledge already exists${NC}"
else
  echo -e "        ${BLUE}+ Creating compound-mind-knowledge${NC}"
  openclaw cron add --name "compound-mind-knowledge" \
    --cron "30 2 * * 0" \
    --agent "$AGENT_ID" \
    --model "$MODEL" \
    --message "Knowledge validation: 1. Read MEMORY.md, life/decisions/, docs/solutions/, memory/*.md 2. Check for: stale content (>30 days old), isolated content (no references), duplicate content (similar entries) 3. Write findings to life/health-state.json under 'validation' key 4. Alert owner if critical issues found."
fi

# compound-mind-optimizer
if echo "$EXISTING_TASKS" | grep -q "^compound-mind-optimizer$"; then
  echo -e "        ${DIM}✓ compound-mind-optimizer already exists${NC}"
else
  echo -e "        ${BLUE}+ Creating compound-mind-optimizer${NC}"
  openclaw cron add --name "compound-mind-optimizer" \
    --cron "0 3 * * 0" \
    --agent "$AGENT_ID" \
    --model "$MODEL" \
    --message "Nighttime optimizer: System health maintenance."
fi

# compound-mind-monitor (v1.4.0+)
if echo "$EXISTING_TASKS" | grep -q "^compound-mind-monitor$"; then
  echo -e "        ${DIM}✓ compound-mind-monitor already exists${NC}"
else
  echo -e "        ${BLUE}+ Creating compound-mind-monitor${NC}"
  openclaw cron add --name "compound-mind-monitor" \
    --cron "0 22 * * *" \
    --agent "$AGENT_ID" \
    --model "$MODEL" \
    --message "Monitor task: 1. Check all flywheel task status 2. Check directory structure 3. Check MEMORY.md update 4. Generate observation report to life/observation-reports/YYYY-MM-DD.md 5. Update life/health-state.json. Reply MONITOR_OK if all good, or alert if issues found."
fi

echo -e "        ${GREEN}✓ Done${NC}"

# Step 5: Log update
echo -e "  ${DIM}[5/4]${NC} Logging update..."

LOG_FILE="$SCRIPT_DIR/logs/update.log"
LOG_TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

if [ ! -f "$LOG_FILE" ]; then
  echo "# Compound Mind Update Log" > "$LOG_FILE"
  echo "# Format: [TIMESTAMP] [OLD_VERSION] → [NEW_VERSION] [STATUS] [BACKUP]" >> "$LOG_FILE"
  echo "" >> "$LOG_FILE"
fi

echo "[${LOG_TIMESTAMP}] ${LOCAL_VERSION} → ${REMOTE_VERSION} SUCCESS backup:${BACKUP_TIMESTAMP}" >> "$LOG_FILE"

echo -e "        ${GREEN}✓ Logged to logs/update.log${NC}"

# ─────────────────────────────────────────────────────────────────────────────
# Complete
# ─────────────────────────────────────────────────────────────────────────────

echo ""
echo -e "  ${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "  ${BOLD}${GREEN}   ✓ Update Complete!${NC}"
echo -e "  ${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "  ${BOLD}Updated:${NC}"
echo -e "    ✅ compound-mind.config.json → ${REMOTE_VERSION}"
echo -e "    ✅ Directory structure"
echo -e "    ✅ AGENTS.md rules"
echo -e "    ✅ Cron tasks (incremental)"
echo -e "    ✅ Backup created: backups/${BACKUP_TIMESTAMP}"
echo -e "    ✅ Update logged"
echo ""
echo -e "  ${BLUE}Framework updated to latest version! 🐢${NC}"
echo ""
