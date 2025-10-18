#!/bin/bash

# =================================================================
# STARTUP SCRIPT for the Intensive Computing Stack
#
# USAGE: ./start_stack.sh
#
# This script starts the Hadoop HDFS and YARN services.
# Run this after you have rebooted your VM.
# =================================================================

# Check if services are already running
if jps | grep -q NameNode || jps | grep -q ResourceManager; then
  echo "⚠️ Hadoop services appear to be already running."
  jps
  echo "If this is an error, please run 'stop_stack.sh' first."
  exit 1
fi

echo "▶️ Starting Hadoop HDFS daemons..."
start-dfs.sh

echo "▶️ Starting Hadoop YARN daemons..."
start-yarn.sh

echo ""
echo "🔍 Verifying running processes with 'jps':"
jps
echo ""
echo "✅ Stack services started successfully!"
echo ""
echo "--- Next Steps ---"
echo "1. Activate the Python environment:"
echo "   source ~/dataenv/bin/activate"
echo ""
echo "2. Start Jupyter Lab:"
echo "   jupyter lab"
echo "----------------------"