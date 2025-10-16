# Update package lists
sudo apt update -y

# Install OpenJDK 11
sudo apt-get install openjdk-11-jdk -y

# Navigate to Downloads directory
cd Download/

# Download Hadoop 3.4.1 tarball
curl -O https://downloads.apache.org/hadoop/common/hadoop-3.4.1/hadoop-3.4.1.tar.gz

# Extract the Hadoop tarball
tar -xzvf hadoop-3.4.1.tar.gz

# Move Hadoop to /usr/local
sudo mv hadoop-3.4.1 /usr/local/hadoop

# Set Hadoop environment variables in .zshrc
echo 'export HADOOP_HOME=/usr/local/hadoop' >> ~/.zshrc
echo 'export PATH=$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$PATH' >> ~/.zshrc
echo 'export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop' >> ~/.zshrc
echo 'export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-arm64' >> ~/.zshrc
echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.zshrc

# Apply the new environment variable settings
source ~/.zshrc

# Configure Hadoop for pseudo-distributed mode

# Change directory to Hadoop configuration folder
cd /usr/local/hadoop/etc/hadoop

# Edit core-site.xml configuration file
nano core-site.xml

# Paste the following content into core-site.xml:
<configuration>
  <property>
    <name>fs.defaultFS</name>
    <value>hdfs://localhost:9000</value>
  </property>
</configuration>
# Save (Ctrl + O) and exit (Ctrl + X)

# Edit hdfs-site.xml configuration file
nano hdfs-site.xml

# Paste the following content into hdfs-site.xml:
<configuration>
  <property>
    <name>dfs.replication</name>
    <value>1</value>
  </property>
  <property>
    <name>dfs.namenode.name.dir</name>
    <value>file:///usr/local/hadoop/hdfs/namenode</value>
  </property>
  <property>
    <name>dfs.datanode.data.dir</name>
    <value>file:///usr/local/hadoop/hdfs/datanode</value>
  </property>
</configuration>
# Save and exit as before

# Initialize HDFS and start Hadoop daemons

# Create directories for NameNode and DataNode storage
mkdir -p /usr/local/hadoop/hdfs/namenode
mkdir -p /usr/local/hadoop/hdfs/datanode

# Format the NameNode filesystem
hdfs namenode -format

# Start all Hadoop daemons
start-all.sh

# Start NameNode daemon (sometimes required)
hdfs --daemon start namenode

# Start DataNode daemon
hdfs --daemon start datanode

# Check running Java processes to verify daemons are active
jps

# Expected output:
# --> NameNode
#     DataNode
#     SecondaryNameNode

# Create a directory in HDFS
hdfs dfs -mkdir /hdfs_dir

# Verify that the directory was created successfully
hdfs dfs -ls /

# ================================================
# Install Apache Spark 3.5.7 on Ubuntu (with Hadoop 3)
# ================================================

# Navigate to Downloads folder
cd ~/Downloads

# Download Spark 3.5.7 binary with Hadoop 3 support
wget https://downloads.apache.org/spark/spark-3.5.7/spark-3.5.7-bin-hadoop3.tgz

# Extract the Spark tarball
tar -xzf spark-3.5.7-bin-hadoop3.tgz

# Move Spark to /usr/local for system-wide access
sudo mv spark-3.5.7-bin-hadoop3 /usr/local/spark3

# Add Spark environment variables (example for Zsh)
echo 'export SPARK_HOME=/usr/local/spark3' >> ~/.zshrc
echo 'export PATH=$SPARK_HOME/bin:$PATH' >> ~/.zshrc

# Apply the new environment variable settings
source ~/.zshrc

# (If using Bash, edit ~/.bashrc instead of ~/.zshrc)

# Verify Spark installation
spark-shell --version

# ================================================
# Verify package authenticity with GPG
# ================================================

# Update package lists and install GnuPG if not installed
sudo apt update
sudo apt install gnupg -y

# Navigate to Downloads folder
cd ~/Downloads

# Download the Spark signature file
wget https://downloads.apache.org/spark/spark-3.5.7/spark-3.5.7-bin-hadoop3.tgz.asc

# Download and import the Apache Spark KEYS file
wget https://downloads.apache.org/spark/KEYS
gpg --import KEYS

# Verify the Spark tarball using GPG
gpg --verify spark-3.5.7-bin-hadoop3.tgz.asc spark-3.5.7-bin-hadoop3.tgz

# Expected message: "Good signature from Apache Software Foundation..."

# ================================================
# Done! Launch Spark
# ================================================


# Install Python 3 and pip
sudo apt-get install python3 -y
sudo apt-get install python3-pip -y

# Install Jupyter Notebook
sudo apt install jupyter-notebook -y

# Install virtual environment support for Python 3.12+
sudo apt install python3.12-venv -y

# Create a virtual environment
python3 -m venv dataenv

# Activate the virtual environment
source dataenv/bin/activate

# Install Jupyter inside the virtual environment
pip install jupyter -y

