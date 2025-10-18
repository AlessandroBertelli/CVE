# Intensive Computing Data Stack on Ubuntu

Here you can download directly the virtual machine for UTM 

https://drive.google.com/file/d/12jBt3WJE2RvTruneiQZeto3FPnXsa-YE/view?usp=share_link

## 📝 Overview

This project provides a set of shell scripts to fully automate the setup of a complete data engineering stack on a fresh Ubuntu virtual machine. It's designed for intensive computing and data analysis tasks, creating an integrated environment with:

* **Apache Hadoop**: For distributed data storage (**HDFS**) and cluster resource management (**YARN**).
* **Apache Spark**: For high-performance, in-memory data processing.
* **Jupyter Lab**: For interactive data science and analysis in a web-based environment.
* **Python**: A dedicated virtual environment with essential libraries like `pyspark`, `pandas`, and `numpy`.

The scripts handle all dependencies, configurations, permissions, and environment variable settings, ensuring that Hadoop, Spark, and Jupyter work together seamlessly.

---

## 🚀 Getting Started

Follow these steps to deploy the entire stack on your virtual machine.

### Prerequisites

* A virtual machine running a fresh, Debian-based OS like **Ubuntu 20.04 LTS** or **22.04 LTS**.
* `sudo` (administrator) privileges on the VM.
* Internet access to download the required packages.

### Installation (Run This Only Once)

This is the main installation process. It downloads and configures all the necessary software.

1.  **Clone the repository or download the scripts** to your VM's home directory.

2.  **Make the installation script executable**:
    ```bash
    chmod +x install_stack.sh
    ```

3.  **Run the script**:
    ```bash
    ./install_stack.sh
    ```
    This process will take several minutes. It will download Hadoop and Spark, set up the configuration files, and prepare the Python environment.

4.  **Reboot the VM** after the script completes to ensure all settings are correctly applied:

    ```bash
    sudo reboot
    ```

---

##  (Daily Usage)

After the one-time installation, use the following commands to manage your data environment.

### 1. Start the Services

Every time you restart your VM, you need to start the Hadoop daemons.

1.  Open a terminal and make the start script executable:
    ```bash
    chmod +x start_stack.sh
    ```
2.  Run the script to start HDFS and YARN:
    ```bash
    ./start_stack.sh
    ```
    You can verify that the processes are running with the `jps` command. You should see `NameNode`, `DataNode`, `ResourceManager`, and `NodeManager` listed.

### 2. Launch Jupyter Lab

To start working with your notebooks:

1.  **Activate the Python virtual environment**:
    ```bash
    source ~/dataenv/bin/activate
    ```
    Your terminal prompt should now be prefixed with `(dataenv)`.

2.  **Start Jupyter Lab**:
    ```bash
    jupyter lab
    ```
    This will provide a URL in the terminal. Copy and paste it into your host machine's web browser to access the Jupyter interface.

### 3. Stop the Services

Before shutting down your VM, it's a best practice to cleanly stop all Hadoop services to prevent HDFS from becoming corrupted.

1.  Make the stop script executable:
    ```bash
    chmod +x stop_stack.sh
    ```

2.  Run the script to safely stop HDFS and YARN:
    ```bash
    ./stop_stack.sh
    ```

---

## 📜 Scripts Overview

* **`install_stack.sh`**: The main installation script. It handles system dependencies, downloads/configures Hadoop and Spark, creates the Python environment, and sets up all necessary environment variables. **Use it only once.**

* **`start_stack.sh`**: A lightweight script to start the HDFS and YARN daemons. **Use this every time you boot your VM.**

* **`stop_stack.sh`**: A lightweight script to safely stop the HDFS and YARN daemons. **Use this before you shut down your VM.**