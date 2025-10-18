# Unified Manual Installation and Operation Guide

# This guide provides the manual commands to install, start, and stop the data stack, reflecting the exact logic from the install_stack.sh, start_stack.sh, and stop_stack.sh scripts.

# echo command are just reported for traciability of command

# Part 1: One-Time Installation
# Run these commands only once on a clean system.

# 1. Install System Dependencies

# This will update your system, add a repository for the correct # Python version, and install Java 11, Python 3.11, and SSH.

Bash
# Update package lists
sudo apt-get update -y

# Install prerequisites for adding repositories
sudo apt-get install -y software-properties-common

# Add the 'deadsnakes' PPA for Python 3.11
sudo add-apt-repository ppa:deadsnakes/ppa -y

# Install all required packages
sudo apt-get install -y openjdk-11-jdk python3.11 python3.11-venv ssh

# 2. Configure Passwordless SSH

# This is required for Hadoop's daemons to communicate with each other.

Bash
# Generate an SSH key if one doesn't exist
if [ ! -f "$HOME/.ssh/id_rsa" ]; then
  ssh-keygen -t rsa -P '' -f "$HOME/.ssh/id_rsa"
fi

# Authorize the key for localhost access
cat "$HOME/.ssh/id_rsa.pub" >> "$HOME/.ssh/authorized_keys"

# Set correct permissions
chmod 0600 "$HOME/.ssh/authorized_keys"

# 3. Install Apache Hadoop (v3.4.1)

# This section downloads, extracts, and configures Hadoop.

Bash
# Define installation variables
INSTALL_DIR="/usr/local"
DOWNLOAD_DIR="$HOME/Downloads"
SETUP_USER="$USER"

# Create Downloads directory and navigate into it
mkdir -p "$DOWNLOAD_DIR"
cd "$DOWNLOAD_DIR"

# Download Hadoop
wget "https://downloads.apache.org/hadoop/common/hadoop-3.4.1/hadoop-3.4.1.tar.gz"

# Extract Hadoop
tar -xzvf "hadoop-3.4.1.tar.gz"

# Move to the installation directory
sudo mv "hadoop-3.4.1" "$INSTALL_DIR/hadoop"

# Take ownership of the directory
sudo chown -R "$SETUP_USER:$SETUP_USER" "$INSTALL_DIR/hadoop"

# Clean up the downloaded archive
rm "hadoop-3.4.1.tar.gz"


# 4. Configure Hadoop (HDFS & YARN)

# These commands will write the necessary XML configurations.

Bash
# Set Hadoop home for convenience
HADOOP_HOME="/usr/local/hadoop"

# Auto-detect JAVA_HOME path
DETECTED_JAVA_HOME=$(readlink -f $(which java) | sed "s:/bin/java::")

# 1. Configure hadoop-env.sh
echo "export JAVA_HOME=$DETECTED_JAVA_HOME" >> "$HADOOP_HOME/etc/hadoop/hadoop-env.sh"

# 2. Configure core-site.xml
cat > "$HADOOP_HOME/etc/hadoop/core-site.xml" <<EOF
<configuration>
    <property><name>fs.defaultFS</name><value>hdfs://localhost:9000</value></property>
</configuration>
EOF

# 3. Configure hdfs-site.xml
cat > "$HADOOP_HOME/etc/hadoop/hdfs-site.xml" <<EOF
<configuration>
    <property><name>dfs.replication</name><value>1</value></property>
    <property><name>dfs.namenode.name.dir</name><value>file://$HADOOP_HOME/data/hdfs/namenode</value></property>
    <property><name>dfs.datanode.data.dir</name><value>file://$HADOOP_HOME/data/hdfs/datanode</value></property>
</configuration>
EOF

# 4. Configure mapred-site.xml (for YARN)
cat > "$HADOOP_HOME/etc/hadoop/mapred-site.xml" <<EOF
<configuration>
    <property><name>mapreduce.framework.name</name><value>yarn</value></property>
</configuration>
EOF

# 5. Configure yarn-site.xml
cat > "$HADOOP_HOME/etc/hadoop/yarn-site.xml" <<EOF
<configuration>
    <property><name>yarn.nodemanager.aux-services</name><value>mapreduce_shuffle</value></property>
</configuration>
EOF

# 6. Create HDFS data directories
mkdir -p "$HADOOP_HOME/data/hdfs/namenode"
mkdir -p "$HADOOP_HOME/data/hdfs/datanode"
# 5. Install Apache Spark (v3.5.7)

# This downloads and extracts Spark, compatible with Hadoop 3.

Bash
# Navigate back to Downloads
cd "$DOWNLOAD_DIR"

# Download Spark
wget "https://downloads.apache.org/spark/spark-3.5.7/spark-3.5.7-bin-hadoop3.tgz"

# Extract Spark
tar -xzf "spark-3.5.7-bin-hadoop3.tgz"

# Move to the installation directory (as /usr/local/spark)
sudo mv "spark-3.5.7-bin-hadoop3" "$INSTALL_DIR/spark"

# Take ownership
sudo chown -R "$SETUP_USER:$SETUP_USER" "$INSTALL_DIR/spark"

# Clean up
rm "spark-3.5.7-bin-hadoop3.tgz"

# 6. Setup Python Environment

# This creates a dedicated Python 3.11 virtual environment named dataenv and installs libraries.

Bash
# Define Python environment name
PYTHON_VENV_NAME="dataenv"

# Create the virtual environment
python3.11 -m venv "$HOME/$PYTHON_VENV_NAME"

# Activate the environment
source "$HOME/$PYTHON_VENV_NAME/bin/activate"

# Upgrade pip
pip install --upgrade pip

# Install required Python libraries
pip install pyspark jupyterlab pandas numpy matplotlib ipykernel

# Register this environment as a Jupyter kernel
python -m ipykernel install --user --name=spark_env_kernel --display-name="Python 3.11 (Spark)"

# Deactivate the environment for now
deactivate

# 7. Configure Environment Variables

# This will add all necessary paths to your .bashrc file.

Bash
# Re-detect Java and set variables
DETECTED_JAVA_HOME=$(readlink -f $(which java) | sed "s:/bin/java::")
INSTALL_DIR="/usr/local"
PYTHON_VENV_NAME="dataenv"

# Append all variables to .bashrc in one block
cat >> "$HOME/.bashrc" <<EOF

# --- Data Stack Environment Variables ---
export JAVA_HOME=$DETECTED_JAVA_HOME
export HADOOP_HOME=$INSTALL_DIR/hadoop
export SPARK_HOME=$INSTALL_DIR/spark
export HADOOP_CONF_DIR=\$HADOOP_HOME/etc/hadoop
export PATH=\$HADOOP_HOME/bin:\$HADOOP_HOME/sbin:\$SPARK_HOME/bin:\$PATH
export PYSPARK_PYTHON=\$HOME/$PYTHON_VENV_NAME/bin/python
export PYSPARK_DRIVER_PYTHON=\$HOME/$PYTHON_VENV_NAME/bin/python
# ------------------------------------
EOF

# 8. Finalize Installation

# Apply the new environment variables and format the HDFS.

Bash
# Apply the .bashrc changes to the current session
source "$HOME/.bashrc"

# Format the HDFS NameNode (run this ONLY ONCE)
hdfs namenode -format -nonInteractive

echo "✅✅✅ ONE-TIME INSTALLATION COMPLETE! ✅✅✅"
echo "Please REBOOT your system now."

# Part 2: Starting the Stack
# Run these commands after you have rebooted your system.

Bash
# Start Hadoop HDFS daemons (NameNode, DataNode, etc.)
echo "▶️ Starting Hadoop HDFS daemons..."
start-dfs.sh

# Start Hadoop YARN daemons (ResourceManager, NodeManager)
echo "▶️ Starting Hadoop YARN daemons..."
start-yarn.sh

# Check that all processes are running
echo "🔍 Verifying running processes with 'jps':"
jps
# Your jps output should show: NameNode, DataNode, SecondaryNameNode, ResourceManager, NodeManager, and Jps.

# Next Steps (Usage)

# To use the stack, activate your environment and start Jupyter:

Bash
# 1. Activate the Python environment:
source ~/dataenv/bin/activate

# 2. Start Jupyter Lab (it will open in your browser):
jupyter lab
# Part 3: Stopping the Stack
# Run these commands before you shut down your system to stop all services cleanly.

Bash
# Stop YARN daemons
echo "⏹️ Stopping Hadoop YARN daemons..."
stop-yarn.sh

# Stop HDFS daemons
echo "⏹️ Stopping Hadoop HDFS daemons..."
stop-dfs.sh

# Verify that all processes have stopped
echo "🔍 Verifying processes have stopped with 'jps':"
jps

echo "✅ Stack services have been stopped."