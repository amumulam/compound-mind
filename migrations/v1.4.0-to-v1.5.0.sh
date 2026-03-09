#!/bin/bash

# Migration: v1.4.0 → v1.5.0
# Usage: ./migrations/v1.4.0-to-v1.5.0.sh [workspace_path]

WORKSPACE="${1:-$(pwd)}"
AGENT_ID=$(basename "$WORKSPACE" | sed 's/workspace-//')

echo "Migrating Compound Mind from v1.4.0 to v1.5.0..."
echo "Workspace: $WORKSPACE"
echo "Agent ID: $AGENT_ID"
echo ""

# Step 1: Update health-state.json structure
echo "[1/3] Updating health-state.json structure..."

if [ -f "$WORKSPACE/life/health-state.json" ]; then
  # Backup old file
  cp "$WORKSPACE/life/health-state.json" "$WORKSPACE/life/health-state.json.backup.v1.4.0"
  
  # Create new structure
  cat > "$WORKSPACE/life/health-state.json" << 'EOF'
{
  "version": "1.5.0",
  "lastCheck": null,
  "flywheel": {
    "checkpoint": { "status": "unknown", "lastRun": null, "nextRun": null },
    "compound": { "status": "unknown", "lastRun": null, "nextRun": null },
    "knowledge": { "status": "unknown", "lastRun": null, "nextRun": null },
    "optimizer": { "status": "unknown", "lastRun": null, "nextRun": null },
    "monitor": { "status": "unknown", "lastRun": null, "nextRun": null }
  },
  "directoryCheck": {
    "docs/solutions": false,
    "docs/plans": false,
    "docs/brainstorms": false,
    "life/decisions": false,
    "life/observation-reports": false,
    "memory": false,
    "invalidDirs": []
  },
  "contentCheck": {
    "memoryUpdated": false,
    "memoryLastUpdate": null,
    "observationReportGenerated": false,
    "todayLogExists": false
  },
  "alerts": []
}
EOF
  echo "  ✓ health-state.json updated"
else
  echo "  ✗ health-state.json not found, skipping"
fi

# Step 2: Create observation-reports directory
echo "[2/3] Creating observation-reports directory..."

mkdir -p "$WORKSPACE/life/observation-reports"
echo "  ✓ life/observation-reports/ created"

# Step 3: Update config version
echo "[3/3] Updating config version..."

if [ -f "$WORKSPACE/compound-mind.config.json" ]; then
  # Backup old file
  cp "$WORKSPACE/compound-mind.config.json" "$WORKSPACE/compound-mind.config.json.backup.v1.4.0"
  
  # Update version and add tasks list
  cat > "$WORKSPACE/compound-mind.config.json" << EOF
{
  "version": "1.5.0",
  "name": "compound-mind",
  "cronModel": "bailian-coding-plan/glm-4.7",
  "tasks": {
    "checkpoint": {
      "name": "compound-mind-checkpoint",
      "schedule": "every 6h"
    },
    "compound": {
      "name": "compound-mind-compound",
      "schedule": "0 4 * * *"
    },
    "knowledge": {
      "name": "compound-mind-knowledge",
      "schedule": "30 2 * * 0"
    },
    "optimizer": {
      "name": "compound-mind-optimizer",
      "schedule": "0 3 * * 0"
    },
    "monitor": {
      "name": "compound-mind-monitor",
      "schedule": "0 22 * * *"
    }
  }
}
EOF
  echo "  ✓ compound-mind.config.json updated"
else
  echo "  ✗ compound-mind.config.json not found, skipping"
fi

echo ""
echo "✅ Migration v1.4.0 → v1.5.0 complete!"
echo ""
echo "Backup files created:"
echo "  - life/health-state.json.backup.v1.4.0"
echo "  - compound-mind.config.json.backup.v1.4.0"
