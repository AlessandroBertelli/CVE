#!/bin/bash

# ==================================================
# Apache Hadoop 3.4.1 Installation Script for Ubuntu
# ==================================================

echo "📦 Installing Java 11..."
sudo apt update
sudo apt-get install -y openjdk-11-jdk

echo "📥 Downloading Hadoop..."
cd ~/Downloads
curl -O https://downloads.apache.org/hadoop/common/hadoop-3.4.1/hadoop-3.4.1.tar.gz

echo "📂 Extracting Hadoop..."
tar -xzvf hadoop-3.4.1.tar.gz

echo "🚚 Moving Hadoop to /usr/local..."
sudo mv hadoop-3.4.1 /usr/local/hadoop

echo "🔧 Configuring environment variables..."
echo 'export HADOOP_HOME=/usr/local/hadoop' >> ~/.zshrc
echo 'export PATH=$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$PATH' >> ~/.zshrc
echo 'export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop' >> ~/.zshrc
echo 'export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-arm64' >> ~/.zshrc
echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.zshrc
source ~/.zshrc

echo "📝 Writing Hadoop configuration files..."
cd /usr/local/hadoop/etc/hadoop

cat > core-site.xml <<EOF
<configuration>
  <property>
    <name>fs.defaultFS</name>
    <value>hdfs://localhost:9000</value>
  </property>
</configuration>
EOF

cat > hdfs-site.xml <<EOF
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
EOF

echo "📁 Creating NameNode and DataNode directories..."
mkdir -p /usr/local/hadoop/hdfs/namenode
mkdir -p /usr/local/hadoop/hdfs/datanode

echo "🧹 Formatting HDFS NameNode..."
hdfs namenode -format

echo "🚀 Starting Hadoop daemons..."
start-all.sh
hdfs --daemon start namenode
hdfs --daemon start datanode

echo "🔍 Verifying Hadoop processes with jps:"
jps

echo "✅ Hadoop installation complete!"

