#!/bin/bash

# =====================================================
# Python Environment + Jupyter + PySpark Setup Script
# =====================================================

echo "🐍 Installing Python 3 and pip..."
sudo apt-get install python3 -y
sudo apt-get install python3-pip -y

echo "🧪 Installing Jupyter Notebook..."
sudo apt install jupyter-notebook -y

echo "📦 Installing Python venv support..."
sudo apt install python3.12-venv -y

echo "📁 Creating Python virtual environment in ~/myenv"
python3 -m venv ~/myenv

echo "📲 Activating virtual environment..."
source ~/myenv/bin/activate

echo "⬇️ Installing Jupyter and PySpark..."
pip install jupyter pyspark

echo ""
echo "✅ Jupyter + PySpark setup complete!"
echo "👉 To activate the virtual environment again later, run:"
echo "   source ~/myenv/bin/activate"
echo "👉 To start Jupyter Notebook, run:"
echo "   jupyter notebook"

