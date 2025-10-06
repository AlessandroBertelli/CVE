#!/bin/bash

# ============================================
# Apache Spark 3.5.7 Installation Script
# ============================================

echo "📥 Downloading Apache Spark 3.5.7..."
cd ~/Downloads
wget https://downloads.apache.org/spark/spark-3.5.7/spark-3.5.7-bin-hadoop3.tgz

echo "📂 Extracting Spark..."
tar -xzf spark-3.5.7-bin-hadoop3.tgz

echo "🚚 Moving Spark to /usr/local..."
sudo mv spark-3.5.7-bin-hadoop3 /usr/local/spark3

echo "🔧 Configuring environment variables..."
echo 'export SPARK_HOME=/usr/local/spark3' >> ~/.zshrc
echo 'export PATH=$SPARK_HOME/bin:$PATH' >> ~/.zshrc
source ~/.zshrc

echo "🧪 Verifying Spark installation..."
spark-shell --version

echo "✅ Spark installation complete!"

