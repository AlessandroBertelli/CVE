#!/bin/bash

# =================================================================
# SHUTDOWN SCRIPT for the Intensive Computing Stack
#
# USAGE: ./stop_stack.sh
#
# This script cleanly stops the Hadoop HDFS and YARN services.
# It is highly recommended to run this before shutting down your VM.
# =================================================================

echo "⏹️ Stopping Hadoop YARN daemons..."
stop-yarn.sh

echo "⏹️ Stopping Hadoop HDFS daemons..."
stop-dfs.sh

echo ""
echo "🔍 Verifying processes have stopped with 'jps':"
jps
echo ""
echo "✅ Stack services have been stopped."