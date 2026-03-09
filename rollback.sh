#!/bin/bash

# Compound Mind Framework - Rollback Script
# Usage: ./rollback.sh [backup_timestamp]

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

# Defaults
DEFAULT_OPENCLAW_DIR="/root/.openclaw"
OPENCLAW_DIR=""
WORKSPACE=""
BACKUP_TIMESTAMP="$1"

# ─────────────────────────────────────────────────────────────────────────────
# Header
# ─────────────────────────────────────────────────────────────────────────────

clear
echo ""
echo -e "  ${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "  ${BOLD}${BLUE}   ⏮️  Compound Mind Framework Rollback${NC}"
echo -e "  ${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# ─────────────────────────────────────────────────────────────────────────────
# Select OpenClaw Directory
# ─────────────────────────────────────────────────────────────────────────────

echo -e "  ${BOLD}[Step 1/3]${NC} Select OpenClaw installation directory"
echo ""
echo -e "  1) Default: ${DEFAULT_OPENCLAW_DIR}"
echo -e "  2) Custom path"
echo ""
echo -n "  ➜ "
read -r choice

if [ "$choice" = "2" ]; then
  echo ""
  echo -e "  ${YELLOW}Enter OpenClaw installation path:${NC}"
  echo -n "  ➜ "
  read -r OPENCLAW_DIR
else
  OPENCLAW_DIR="$DEFAULT_OPENCLAW_DIR"
fi

if [ ! -d "$OPENCLAW_DIR" ]; then
  echo -e "  ${RED}✗ Directory not found: ${OPENCLAW_DIR}${NC}"
  exit 1
fi

echo -e "  ${GREEN}✓ Selected:${NC} ${OPENCLAW_DIR}"
echo ""

# ─────────────────────────────────────────────────────────────────────────────
# Select Workspace
# ─────────────────────────────────────────────────────────────────────────────

echo -e "  ${BOLD}[Step 2/3]${NC} Select workspace"
echo ""

WORKSPACES=()
while IFS= read -r -d '' dir; do
  WORKSPACES+=("$(basename "$dir")")
done < <(find "$OPENCLAW_DIR" -maxdepth 1 -type d -name "workspace-*" -print0 2>/dev/null | sort -z)

if [ ${#WORKSPACES[@]} -eq 0 ]; then
  echo -e "  ${RED}✗ No workspace directories found${NC}"
  exit 1
fi

echo "  Available workspaces:"
for i in "${!WORKSPACES[@]}"; do
  echo -e "    $((i+1))) ${WORKSPACES[$i]}"
done
echo ""
echo -n "  ➜ "
read -r ws_choice

WORKSPACE="${OPENCLAW_DIR}/${WORKSPACES[$((ws_choice-1))]}"

echo -e "  ${GREEN}✓ Selected:${NC} ${WORKSPACES[$((ws_choice-1))]}"
echo ""

# ─────────────────────────────────────────────────────────────────────────────
# Select Backup
# ─────────────────────────────────────────────────────────────────────────────

echo -e "  ${BOLD}[Step 3/3]${NC} Select backup to restore"
echo ""

BACKUP_DIR="$WORKSPACE/backups"

if [ ! -d "$BACKUP_DIR" ]; then
  echo -e "  ${RED}✗ No backups found${NC}"
  exit 1
fi

BACKUPS=()
while IFS= read -r -d '' dir; do
  BACKUPS+=("$(basename "$dir")")
done < <(find "$BACKUP_DIR" -maxdepth 1 -type d -name "*" -print0 2>/dev/null | sort -rz)

if [ ${#BACKUPS[@]} -eq 0 ]; then
  echo -e "  ${RED}✗ No backups found${NC}"
  exit 1
fi

echo "  Available backups:"
for i in "${!BACKUPS[@]}"; do
  if [ -n "${BACKUPS[$i]}" ] && [ "${BACKUPS[$i]}" != "backups" ]; then
    echo -e "    $((i+1))) ${BACKUPS[$i]}"
  fi
done
echo ""
echo -n "  ➜ "
read -r backup_choice

SELECTED_BACKUP="${BACKUPS[$((backup_choice-1))]}"
BACKUP_PATH="$BACKUP_DIR/$SELECTED_BACKUP"

echo -e "  ${GREEN}✓ Selected:${NC} ${SELECTED_BACKUP}"
echo ""

# ─────────────────────────────────────────────────────────────────────────────
# Confirmation
# ─────────────────────────────────────────────────────────────────────────────

echo -e "  ${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "  ${BOLD}Rollback Summary${NC}"
echo -e "  ${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "  Workspace: ${GREEN}${WORKSPACES[$((ws_choice-1))]}${NC}"
echo -e "  Backup:    ${GREEN}${SELECTED_BACKUP}${NC}"
echo ""
echo -e "  ${YELLOW}⚠ This will overwrite current files with backup versions${NC}"
echo ""
echo -e "  ${YELLOW}Continue with rollback? (y/n)${NC}"
echo -n "  ➜ "
read -r confirm

if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
  echo -e "  ${YELLOW}Rollback cancelled${NC}"
  exit 0
fi

echo ""

# ─────────────────────────────────────────────────────────────────────────────
# Rollback
# ─────────────────────────────────────────────────────────────────────────────

echo -e "  ${BLUE}Rolling back...${NC}"
echo ""

# Restore files
if [ -d "$BACKUP_PATH" ]; then
  for file in "$BACKUP_PATH"/*; do
    if [ -f "$file" ]; then
      filename=$(basename "$file")
      echo -e "  ${DIM}Restoring:${NC} $filename"
      cp "$file" "$WORKSPACE/$filename"
    fi
  done
  echo -e "  ${GREEN}✓ Files restored${NC}"
else
  echo -e "  ${RED}✗ Backup not found: $BACKUP_PATH${NC}"
  exit 1
fi

echo ""
echo -e "  ${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "  ${BOLD}${GREEN}   ✓ Rollback Complete!${NC}"
echo -e "  ${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "  ${BLUE}Framework rolled back to ${SELECTED_BACKUP}${NC}"
echo ""
