# ⚙️ Big Data Setup on Ubuntu (Hadoop + Spark + Jupyter)

This guide contains 3 shell scripts to automate the installation and setup of:

- Apache Hadoop 3.4.1
- Apache Spark 3.5.7
- Python Virtual Environment with Jupyter Notebook and PySpark

---

## 📁 Scripts Overview

| Script Name           | Description                                |
|------------------------|--------------------------------------------|
| `install_hadoop.sh`   | Installs and configures Hadoop 3.4.1       |
| `install_spark.sh`    | Installs Apache Spark 3.5.7 with Hadoop 3  |
| `setup_jupyter.sh`    | Creates a Python virtualenv with Jupyter and PySpark |

---

## 🧰 Prerequisites

- Ubuntu 20.04+ or 22.04+
- Terminal access with sudo privileges
- Internet connection
- Shell: tested with `zsh` (you can adapt `.zshrc` to `.bashrc` if needed)

---

## 🚀 Installation Steps

### 1. Clone or prepare your script directory

Make sure all 3 scripts are in the same folder (e.g. `~/bigdata-setup/`).

### 2. Make the scripts executable

chmod +x install_hadoop.sh install_spark.sh setup_jupyter.sh

### 3.cLunch in order the 3 script
./install_hadoop.sh
./install_spark.sh
./setup_jupyter.sh

