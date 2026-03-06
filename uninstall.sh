#!/bin/bash

# Compound Mind Framework - Uninstall Script
# Usage: ./uninstall.sh

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
        '[A')
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
        '[B')
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
# Header
# ─────────────────────────────────────────────────────────────────────────────

clear
echo ""
echo -e "  ${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "  ${BOLD}${RED}   🗑️  Compound Mind Framework Uninstaller${NC}"
echo -e "  ${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "  ${DIM}Use ↑↓ to navigate, Enter to select${NC}"
echo ""

# ─────────────────────────────────────────────────────────────────────────────
# Step 1: Select OpenClaw Directory
# ─────────────────────────────────────────────────────────────────────────────

echo -e "  ${BOLD}[Step 1/2]${NC} Select OpenClaw installation directory"
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

echo -e "  ${BOLD}[Step 2/2]${NC} Select workspace to uninstall"
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
# Confirmation
# ─────────────────────────────────────────────────────────────────────────────

echo -e "  ${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "  ${BOLD}Uninstall Summary${NC}"
echo -e "  ${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "  Workspace: ${GREEN}${WORKSPACES[$workspace_choice]}${NC}"
echo -e "  Agent ID:  ${GREEN}${AGENT_ID}${NC}"
echo ""
echo -e "  ${DIM}Will be REMOVED:${NC}"
echo -e "    • Cron tasks (compound-mind-*)"
echo -e "    • docs/ directory"
echo -e "    • life/ directory"
echo -e "    • Compound Mind rules in AGENTS.md"
echo ""
echo -e "  ${DIM}Will be KEPT:${NC}"
echo -e "    • memory/ directory"
echo -e "    • MEMORY.md"
echo ""
echo -e "  ${RED}Continue with uninstall? (y/n)${NC}"
echo -n "  ➜ "
read -r confirm

if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
  echo -e "  ${YELLOW}Uninstall cancelled${NC}"
  exit 0
fi

echo ""

# ─────────────────────────────────────────────────────────────────────────────
# Uninstall
# ─────────────────────────────────────────────────────────────────────────────

echo -e "  ${BLUE}Uninstalling...${NC}"
echo ""

cd "$WORKSPACE"

# Step 1: Remove Cron tasks
echo -e "  ${DIM}[1/4]${NC} Removing Cron tasks..."

for job_id in $(openclaw cron list --json 2>/dev/null | grep -o '"id":"[^"]*"' | grep -o '[^"]*-[a-f0-9]*' | head -20); do
  job_name=$(openclaw cron list --json 2>/dev/null | grep -A1 "\"id\":\"$job_id\"" | grep '"name"' | grep -o '"name":"[^"]*"' | cut -d'"' -f4)
  if [[ "$job_name" == "compound-mind-"* ]]; then
    openclaw cron remove "$job_id" 2>/dev/null && echo -e "        ${DIM}Removed: ${job_name}${NC}"
  fi
done

echo -e "        ${GREEN}✓ Done${NC}"

# Step 2: Remove docs/ directory
echo -e "  ${DIM}[2/4]${NC} Removing docs/ directory..."
rm -rf docs/
echo -e "        ${GREEN}✓ Done${NC}"

# Step 3: Remove life/ directory
echo -e "  ${DIM}[3/5]${NC} Removing life/ directory..."
rm -rf life/
echo -e "        ${GREEN}✓ Done${NC}"

# Step 4: Remove AGENTS.md rules
echo -e "  ${DIM}[4/5]${NC} Removing AGENTS.md rules..."

if [ -f "AGENTS.md" ]; then
  if grep -q "COMPOUND_MIND_START" "AGENTS.md"; then
    sed -i '/<!-- COMPOUND_MIND_START -->/,/<!-- COMPOUND_MIND_END -->/d' "AGENTS.md"
    echo -e "        ${GREEN}✓ Done${NC}"
  else
    echo -e "        ${DIM}Skipped (marker not found)${NC}"
  fi
fi

# Step 4.5: Remove HEARTBEAT.md rules
echo -e "  ${DIM}[4.5/5]${NC} Removing HEARTBEAT.md rules..."

if [ -f "HEARTBEAT.md" ]; then
  if grep -q "COMPOUND_MIND_START" "HEARTBEAT.md"; then
    sed -i '/<!-- COMPOUND_MIND_START -->/,/<!-- COMPOUND_MIND_END -->/d' "HEARTBEAT.md"
    echo -e "        ${GREEN}✓ Done${NC}"
  else
    echo -e "        ${DIM}Skipped (marker not found)${NC}"
  fi
fi

# ─────────────────────────────────────────────────────────────────────────────
# Complete
# ─────────────────────────────────────────────────────────────────────────────

echo ""
echo -e "  ${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "  ${BOLD}${GREEN}   ✓ Uninstall Complete!${NC}"
echo -e "  ${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "  ${BOLD}Removed:${NC}"
echo -e "    ✅ Cron tasks"
echo -e "    ✅ docs/ directory"
echo -e "    ✅ life/ directory"
echo -e "    ✅ AGENTS.md rules"
echo -e "    ✅ HEARTBEAT.md rules"
echo ""
echo -e "  ${BOLD}Kept:${NC}"
echo -e "    📁 memory/"
echo -e "    📄 MEMORY.md"
echo ""
echo -e "  ${BLUE}Framework removed. Memory preserved. 🐢${NC}"
echo ""