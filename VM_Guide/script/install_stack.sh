#!/bin/bash

# =================================================================
# ONE-TIME INSTALLATION SCRIPT for the Intensive Computing Stack
#
# USAGE: ./install_stack.sh
#
# This script installs and configures the entire data stack.
# Run this script ONLY ONCE on a clean Ubuntu system.
# =================================================================

# Exit immediately if a command fails
set -e

# --- Configuration Variables ---
HADOOP_VERSION="3.4.1"
SPARK_VERSION="3.5.7"
PYTHON_VENV_NAME="dataenv"
INSTALL_DIR="/usr/local"
DOWNLOAD_DIR="$HOME/Downloads"
SETUP_USER="$USER"

# --- Utility function to add configurations to .bashrc ---
add_to_bashrc() {
  local line="$1"
  local file="$HOME/.bashrc"
  if ! grep -qF -- "$line" "$file"; then
    echo "Appending to .bashrc: $line"
    echo "$line" >> "$file"
  fi
}

# --- SCRIPT START ---
echo "🚀 Starting the ONE-TIME installation of the Intensive Computing stack..."
echo "User: $SETUP_USER | Installation directory: $INSTALL_DIR"

# 1. Install System Dependencies
#echo "📦 Installing system dependencies (Java, Python, SSH)..."
#sudo apt-get update -y
#sudo apt-get install -y openjdk-11-jdk python3 python3-pip python3-venv ssh

# 1. Install System Dependencies
echo "📦 Installing system dependencies (Java, Python 3.11, SSH)..."
sudo apt-get update -y
sudo apt-get install -y software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt-get install -y openjdk-11-jdk python3.11 python3.11-venv ssh

# 2. Configure SSH for Hadoop
echo "🔑 Configuring passwordless SSH..."
if [ ! -f "$HOME/.ssh/id_rsa" ]; then
  ssh-keygen -t rsa -P '' -f "$HOME/.ssh/id_rsa"
fi
cat "$HOME/.ssh/id_rsa.pub" >> "$HOME/.ssh/authorized_keys"
chmod 0600 "$HOME/.ssh/authorized_keys"

# 3. Install and Configure Hadoop
echo "🚚 Installing Apache Hadoop v$HADOOP_VERSION..."
mkdir -p "$DOWNLOAD_DIR"
cd "$DOWNLOAD_DIR"
if [ ! -f "hadoop-$HADOOP_VERSION.tar.gz" ]; then
  wget "https://downloads.apache.org/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz"
fi
tar -xzvf "hadoop-$HADOOP_VERSION.tar.gz"
sudo mv "hadoop-$HADOOP_VERSION" "$INSTALL_DIR/hadoop"
sudo chown -R "$SETUP_USER:$SETUP_USER" "$INSTALL_DIR/hadoop"
rm "hadoop-$HADOOP_VERSION.tar.gz"

echo "📝 Configuring Hadoop (HDFS and YARN)..."
HADOOP_HOME="$INSTALL_DIR/hadoop"
DETECTED_JAVA_HOME=$(readlink -f $(which java) | sed "s:/bin/java::")

# Configure hadoop-env.sh, core-site.xml, hdfs-site.xml, mapred-site.xml, yarn-site.xml
echo "export JAVA_HOME=$DETECTED_JAVA_HOME" >> "$HADOOP_HOME/etc/hadoop/hadoop-env.sh"
cat > "$HADOOP_HOME/etc/hadoop/core-site.xml" <<EOF
<configuration>
    <property><name>fs.defaultFS</name><value>hdfs://localhost:9000</value></property>
</configuration>
EOF
cat > "$HADOOP_HOME/etc/hadoop/hdfs-site.xml" <<EOF
<configuration>
    <property><name>dfs.replication</name><value>1</value></property>
    <property><name>dfs.namenode.name.dir</name><value>file://$HADOOP_HOME/data/hdfs/namenode</value></property>
    <property><name>dfs.datanode.data.dir</name><value>file://$HADOOP_HOME/data/hdfs/datanode</value></property>
</configuration>
EOF
cat > "$HADOOP_HOME/etc/hadoop/mapred-site.xml" <<EOF
<configuration>
    <property><name>mapreduce.framework.name</name><value>yarn</value></property>
</configuration>
EOF
cat > "$HADOOP_HOME/etc/hadoop/yarn-site.xml" <<EOF
<configuration>
    <property><name>yarn.nodemanager.aux-services</name><value>mapreduce_shuffle</value></property>
</configuration>
EOF
mkdir -p "$HADOOP_HOME/data/hdfs/namenode"
mkdir -p "$HADOOP_HOME/data/hdfs/datanode"

# 4. Install and Configure Spark
echo "🔥 Installing Apache Spark v$SPARK_VERSION..."
cd "$DOWNLOAD_DIR"
if [ ! -f "spark-$SPARK_VERSION-bin-hadoop3.tgz" ]; then
  wget "https://downloads.apache.org/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop3.tgz"
fi
tar -xzf "spark-$SPARK_VERSION-bin-hadoop3.tgz"
sudo mv "spark-$SPARK_VERSION-bin-hadoop3" "$INSTALL_DIR/spark"
sudo chown -R "$SETUP_USER:$SETUP_USER" "$INSTALL_DIR/spark"
rm "spark-$SPARK_VERSION-bin-hadoop3.tgz"

# 5. Setup Python Environment
echo "🐍 Creating Python virtual environment and installing libraries..."
python3.11 -m venv "$HOME/$PYTHON_VENV_NAME"
source "$HOME/$PYTHON_VENV_NAME/bin/activate"
pip install --upgrade pip
pip install pyspark jupyterlab pandas numpy matplotlib ipykernel
python -m ipykernel install --user --name=spark_env_kernel --display-name="Python 3.11 (Spark)"
deactivate

# 6. Configure Environment Variables
echo "🔧 Writing environment variables to ~/.bashrc..."
add_to_bashrc "# --- Data Stack Environment Variables ---"
add_to_bashrc "export JAVA_HOME=$DETECTED_JAVA_HOME"
add_to_bashrc "export HADOOP_HOME=$INSTALL_DIR/hadoop"
add_to_bashrc "export SPARK_HOME=$INSTALL_DIR/spark"
add_to_bashrc "export HADOOP_CONF_DIR=\$HADOOP_HOME/etc/hadoop"
add_to_bashrc "export PATH=\$HADOOP_HOME/bin:\$HADOOP_HOME/sbin:\$SPARK_HOME/bin:\$PATH"
add_to_bashrc "export PYSPARK_PYTHON=\$HOME/$PYTHON_VENV_NAME/bin/python"
add_to_bashrc "export PYSPARK_DRIVER_PYTHON=\$HOME/$PYTHON_VENV_NAME/bin/python"
add_to_bashrc "# ------------------------------------"

# 7. Final Steps
echo "🔄 Sourcing .bashrc to apply changes for formatting..."
source "$HOME/.bashrc"
source ~/.bashrc

echo "🧹 Formatting HDFS NameNode (this is done only once)... if here it fails please lunch "
echo "this command in a new terminal ==> hdfs namenode -format -nonInteractive " 
hdfs namenode -format -nonInteractive

echo "✅✅✅ ONE-TIME INSTALLATION COMPLETE! ✅✅✅"
echo ""
echo "Please REBOOT your VM now to ensure all services start fresh."
echo "After rebooting, use the 'start_stack.sh' script to launch the services."