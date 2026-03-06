#!/bin/bash

# Compound Mind Framework Installer
# Usage: ./install.sh

# Don't use set -e because select_option uses return values for selection index

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
    
    # Handle escape sequences (arrow keys)
    if [[ "$key" == $'\x1b' ]]; then
      read -rsn2 -t 0.1 key
      case "$key" in
        '[A') # Up arrow
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
        '[B') # Down arrow
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
      # Enter key pressed
      tput cnorm
      echo ""
      return $selected
    elif [[ "$key" == "k" ]] || [[ "$key" == "K" ]]; then
      # k for up (vim style)
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
      # j for down (vim style)
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
# Read models from openclaw.json
# ─────────────────────────────────────────────────────────────────────────────

get_models_from_config() {
  local config_file="$1"
  
  if [ ! -f "$config_file" ]; then
    echo ""
    return
  fi
  
  # Extract model IDs from agents.defaults.models
  # Format: "bailian-coding-plan/glm-5"
  cat "$config_file" | grep -o '"[a-zA-Z0-9-]*/[a-zA-Z0-9._-]*"' | tr -d '"' | sort -u
}

# ─────────────────────────────────────────────────────────────────────────────
# Header
# ─────────────────────────────────────────────────────────────────────────────

clear
echo ""
echo -e "  ${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "  ${BOLD}${BLUE}   🐢 Compound Mind Framework Installer${NC}"
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

echo -e "  ${BOLD}[Step 2/3]${NC} Select workspace to install"
echo ""

WORKSPACES=()
while IFS= read -r -d '' dir; do
  WORKSPACES+=("$(basename "$dir")")
done < <(find "$OPENCLAW_DIR" -maxdepth 1 -type d -name "workspace-*" -print0 2>/dev/null | sort -z)

if [ ${#WORKSPACES[@]} -eq 0 ]; then
  echo -e "  ${RED}✗ No workspace directories found${NC}"
  echo -e "  ${DIM}Create an agent first: openclaw agents add <agent-id>${NC}"
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
# Step 3: Select Model
# ─────────────────────────────────────────────────────────────────────────────

echo -e "  ${BOLD}[Step 3/3]${NC} Select model for Cron tasks"
echo ""

# Read models from openclaw.json
OPENCLAW_CONFIG="${OPENCLAW_DIR}/openclaw.json"
MODELS=()

while IFS= read -r model_id; do
  if [ -n "$model_id" ]; then
    MODELS+=("$model_id")
  fi
done < <(get_models_from_config "$OPENCLAW_CONFIG")

if [ ${#MODELS[@]} -eq 0 ]; then
  echo -e "  ${YELLOW}⚠ No models found in config, using default${NC}"
  MODELS=("bailian-coding-plan/glm-5")
fi

select_option "${MODELS[@]}"
model_choice=$?

MODEL="${MODELS[$model_choice]}"

echo -e "  ${GREEN}✓ Selected:${NC} ${MODEL}"
echo ""

# ─────────────────────────────────────────────────────────────────────────────
# Confirmation
# ─────────────────────────────────────────────────────────────────────────────

echo -e "  ${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "  ${BOLD}Installation Summary${NC}"
echo -e "  ${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "  OpenClaw Directory  : ${GREEN}${OPENCLAW_DIR}${NC}"
echo -e "  Workspace           : ${GREEN}${WORKSPACES[$workspace_choice]}${NC}"
echo -e "  Agent ID            : ${GREEN}${AGENT_ID}${NC}"
echo -e "  Model               : ${GREEN}${MODEL}${NC}"
echo ""
echo -e "  ${YELLOW}Continue with installation? (y/n)${NC}"
echo -n "  ➜ "
read -r confirm

if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
  echo -e "  ${YELLOW}Installation cancelled${NC}"
  exit 0
fi

echo ""

# ─────────────────────────────────────────────────────────────────────────────
# Installation
# ─────────────────────────────────────────────────────────────────────────────

echo -e "  ${BLUE}Installing...${NC}"
echo ""

# Step 1: Create directory structure
echo -e "  ${DIM}[1/4]${NC} Creating directory structure..."

cd "$WORKSPACE"

mkdir -p docs/solutions
mkdir -p docs/plans
mkdir -p docs/brainstorms
mkdir -p life/decisions
mkdir -p life/motivation

[ ! -f "life/motivation/achievements.json" ] && echo '{}' > life/motivation/achievements.json
[ ! -f "life/motivation/milestones.json" ] && echo '{"milestones": [], "nextMilestones": []}' > life/motivation/milestones.json
[ ! -f "life/motivation/streaks.json" ] && echo '{}' > life/motivation/streaks.json
[ ! -f "life/health-state.json" ] && cat > life/health-state.json << 'HEALTHSTATEEOF'
{
  "lastCheck": null,
  "version": "1.0.0",
  "cronTasks": {
    "checkpoint": { "status": "unknown", "lastRun": null, "nextRun": null },
    "compound": { "status": "unknown", "lastRun": null, "nextRun": null },
    "knowledge": { "status": "unknown", "lastRun": null, "nextRun": null },
    "optimizer": { "status": "unknown", "lastRun": null, "nextRun": null }
  },
  "memoryUpdate": null,
  "directoryCheck": {
    "docs/solutions": false,
    "life/decisions": false,
    "memory": false,
    "MEMORY.md": false
  },
  "alerts": []
}
HEALTHSTATEEOF

# Create config file
cat > compound-mind.config.json << CONFIGEOF
{
  "version": "1.0.0",
  "name": "compound-mind",
  "cronModel": "$MODEL"
}
CONFIGEOF

echo -e "        ${GREEN}✓ Done${NC}"

# Step 2: Update AGENTS.md
echo -e "  ${DIM}[2/4]${NC} Appending rules to AGENTS.md..."

AGENTS_FILE="$WORKSPACE/AGENTS.md"

if [ -f "$AGENTS_FILE" ]; then
  if ! grep -q "Compound Mind Rules" "$AGENTS_FILE"; then
    cat >> "$AGENTS_FILE" << 'EOF'

---

## Compound Mind Rules

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
EOF
    echo -e "        ${GREEN}✓ Done${NC}"
  else
    echo -e "        ${DIM}Skipped (already exists)${NC}"
  fi
fi

# Step 3: Install CE Plugin
echo -e "  ${DIM}[3/4]${NC} Installing Compound Engineering Plugin..."

if command -v bun &> /dev/null; then
  bunx @every-env/compound-plugin install compound-engineering --to openclaw 2>/dev/null
  echo -e "        ${GREEN}✓ Done${NC}"
else
  echo -e "        ${RED}✗ bun not found${NC}"
  echo -e "        ${DIM}Install bun: curl -fsSL https://bun.sh/install | bash${NC}"
  exit 1
fi

# Step 4: Configure Cron tasks
echo -e "  ${DIM}[4/4]${NC} Configuring Cron tasks..."

# Remove existing compound-mind tasks to avoid duplicates
for job_id in $(openclaw cron list --json 2>/dev/null | grep -o '"id":"[^"]*"' | cut -d'"' -f4); do
  job_name=$(openclaw cron list --json 2>/dev/null | grep -B1 "\"id\":\"$job_id\"" | grep '"name"' | cut -d'"' -f4)
  if [[ "$job_name" == "compound-mind-"* ]]; then
    openclaw cron remove "$job_id" 2>/dev/null
  fi
done

openclaw cron add --name "compound-mind-checkpoint" \
  --every 6h \
  --agent "$AGENT_ID" \
  --model "$MODEL" \
  --message "Checkpoint extraction: Extract key info from today's log. Steps: 1. Read memory/YYYY-MM-DD.md 2. Extract decisions/learnings/events 3. Write to MEMORY.md. If no content, reply CHECKPOINT_OK."

openclaw cron add --name "compound-mind-compound" \
  --cron "0 4 * * *" \
  --agent "$AGENT_ID" \
  --model "$MODEL" \
  --message "Compound extraction: Extract reusable solutions from logs."

openclaw cron add --name "compound-mind-knowledge" \
  --cron "30 2 * * 0" \
  --agent "$AGENT_ID" \
  --model "$MODEL" \
  --message "Knowledge validation: Check for stale/isolated/duplicate content."

openclaw cron add --name "compound-mind-optimizer" \
  --cron "0 3 * * 0" \
  --agent "$AGENT_ID" \
  --model "$MODEL" \
  --message "Nighttime optimizer: System health maintenance."

echo -e "        ${GREEN}✓ Done${NC}"

# ─────────────────────────────────────────────────────────────────────────────
# Complete
# ─────────────────────────────────────────────────────────────────────────────

echo ""
echo -e "  ${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "  ${BOLD}${GREEN}   ✓ Installation Complete!${NC}"
echo -e "  ${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "  ${BOLD}Installed:${NC}"
echo -e "    ✅ Directory structure"
echo -e "    ✅ AGENTS.md rules"
echo -e "    ✅ Compound Engineering Plugin"
echo -e "    ✅ 5 Cron tasks"
echo ""
echo -e "  ${BOLD}Next steps:${NC}"
echo -e "    1. Use ${CYAN}/ce:plan${NC} to create plans"
echo -e "    2. After tasks, use ${CYAN}/ce:compound${NC} to capture learnings"
echo -e "    3. Let the flywheel run automatically"
echo ""
echo -e "  ${BLUE}Let the flywheel spin! 🐢${NC}"
echo ""