#!/bin/bash

# Benchmark script for checkpoint extraction
JOB_ID="f0397ab3-840a-4ae9-8193-84946ede4c5d"
RESULTS_FILE="/root/.openclaw/workspace-baba/life/archives/benchmark-results.txt"

# Clear results file
> "$RESULTS_FILE"

echo "Starting 10-run benchmark for checkpoint extraction..."
echo "Job ID: $JOB_ID"
echo ""

for i in {1..10}; do
  echo "=== Run $i/10 ===" 
  
  # Get current latest runAtMs
  PREV_RUN_AT=$(openclaw cron runs --id "$JOB_ID" --limit 1 2>/dev/null | jq -r '.entries[0].runAtMs // 0')
  
  # Trigger the job (non-blocking)
  timeout 5 openclaw cron run "$JOB_ID" 2>&1 || true
  
  # Wait for new run to complete (poll for up to 180 seconds)
  echo "Waiting for run to complete..."
  for j in {1..90}; do
    sleep 2
    NEW_RUN_AT=$(openclaw cron runs --id "$JOB_ID" --limit 1 2>/dev/null | jq -r '.entries[0].runAtMs // 0')
    if [ "$NEW_RUN_AT" != "$PREV_RUN_AT" ] && [ "$NEW_RUN_AT" -gt "$PREV_RUN_AT" ]; then
      # New run found
      DURATION=$(openclaw cron runs --id "$JOB_ID" --limit 1 2>/dev/null | jq -r '.entries[0].durationMs')
      echo "Run $i completed: $DURATION ms"
      echo "$DURATION" >> "$RESULTS_FILE"
      break
    fi
    if [ $j -eq 90 ]; then
      echo "Run $i TIMEOUT after 180 seconds"
      echo "TIMEOUT" >> "$RESULTS_FILE"
    fi
  done
  
  # Wait 5 seconds before next run (except for last run)
  if [ $i -lt 10 ]; then
    echo "Waiting 5 seconds before next run..."
    sleep 5
  fi
done

echo ""
echo "=== Benchmark Complete ==="
echo "Results:"
cat "$RESULTS_FILE"