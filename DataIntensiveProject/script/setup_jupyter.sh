#!/bin/bash

# =====================================================
# Python Environment + Jupyter  Setup Script
# =====================================================

echo "🐍 Installing Python 3 and pip..."
sudo apt-get install python3 -y
sudo apt-get install python3-pip -y

echo "🧪 Installing Jupyter Notebook..."
sudo apt install jupyter-notebook -y

echo "📦 Installing Python venv support..."
sudo apt install python3.12-venv -y

echo "📁 Creating Python virtual environment in ~/dataenv"
python3 -m venv ~/dataenv

echo "📲 Activating virtual environment..."
source ~/dataenv/bin/activate

echo ""
echo "✅ Jupyter setup complete!"
echo "👉 To activate the virtual environment again later, run:"
echo "   source ~/dataenv/bin/activate"
echo "👉 To start Jupyter Notebook, run:"
echo "   jupyter notebook"

