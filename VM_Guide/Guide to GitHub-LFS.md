# 1. Install Git

First, open your terminal and ensure Git is installed.
These commands will update your system's package list and install Git.

sudo apt update -y
sudo apt install git -y

# 2. Install Git LFS (Large File Storage)
Next, install the git-lfs package, which is required to handle large files.

sudo apt install git-lfs -y

After the installation, you must initialize Git LFS for your user account.

This command only needs to be run once per system.

git lfs install


# 3. Clone the Repository
Now you are ready to clone.
Use the git clone command followed by the URL you copied.
Git LFS will automatically detect and download the large files during this process.


git clone https://github.com/margherita-santarossa/CVE