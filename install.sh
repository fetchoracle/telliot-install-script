#!/bin/bash

# Check if the directory already exists
if [ -d "$HOME/telliot-feeds" ]; then
  echo "The folder 'telliot-feeds' already exists. Please remove or rename it to save old configs."
  exit 1
fi

echo 
echo "       ╔═════════════════════════════════════════════════════════════════╗"
echo "       ║ This script will install Python, Telliot-feeds and Telliot-core ║" 
echo "       ║           (Optionally you can also choose to install the DVM)   ║"
echo "       ╚═════════════════════════════════════════════════════════════════╝"
echo "If installing in your main machine, please read the install.sh before install!"
echo
cd "$HOME/"
echo "Choose the environment to clone and install: "
echo "1 - Testnet/Main (Default)"
echo "2 - Staging   (QA tests only)"
echo
read -p "Enter 1-testnet or 2-staging: " environment_choice

case $environment_choice in
  1)
    branch="testnet"
    ;;
  2)
    branch="staging"
    ;;
  *)
    echo "Invalid choice. Please enter 1 for testnet/main or 2 for staging."
    exit 1
    ;;
esac
echo "You entered: $branch"
echo
read -p "Do you want to install DVM (Disputable Values Monitor), too? " install_dvm

# Treat empty response (just pressing Enter) as "yes"
install_dvm=${install_dvm:-yes}

case $install_dvm in
  [Yy][Ee][Ss]|[Yy])  # Matches yes, Yes, YES, y, or Y
    dvm="yes"
        echo "Will install Telliot and DVM."
    ;;
  [Nn][Oo]|[Nn])  # Matches no, No, NO, n, or N
    dvm="no"
        echo "Installing only Telliot."
    ;;
  *)
    echo "Invalid choice. Please enter 'y' or 'n'."
    exit 1
    ;;
esac

echo "Cloning branch: $branch"
echo

# Clone the repository with the selected branch
echo "Cloning telliot-feeds..."
git clone -b "$branch" https://github.com/fetchoracle/telliot-feeds.git

if [ $? -eq 0 ]; then
  echo "Telliot-feeds cloned successfully."
else
  echo "Failed to clone telliot-feeds."
  exit 1
fi

echo
echo "Moving to telliot-feeds folder..."
cd "$HOME/telliot-feeds" || { echo "Failed to change directory. Make sure to install it from HOME."; exit 1; }

echo
echo "Installing Python 3.9 and venv..."
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt install -y python3.9 python3.9-venv #python3-pip

# Create and activate the virtual environment
echo
echo "Creating and entering virtual environment..."
python3.9 -m venv venv
source venv/bin/activate

echo
echo "Installing telliot feeds"
pip install -e .

echo
echo "Cloning telliot-core..."
git clone -b "$branch" https://github.com/fetchoracle/telliot-core.git

if [ $? -eq 0 ]; then
  echo "Telliot-core cloned successfully."
else
  echo "Failed to clone telliot-core."
  exit 1
fi

echo
echo "Moving to telliot-core folder..."
cd "$HOME/telliot-feeds/telliot-core" || { echo "Failed to change directory."; exit 1; }

echo
echo "Installing telliot core"
pip install -e .
telliot config init

cd "$HOME/telliot-feeds/" || { echo "Failed to change directory."; exit 1; }

if [ "$dvm" = "yes" ]; then
  echo
  echo "Cloning DVM..."
  git clone -b "$branch" https://github.com/fetchoracle/disputable-values-monitor.git

  if [ $? -eq 0 ]; then
    echo "DVM cloned successfully."
  else
    echo "Failed to clone DVM."
    exit 1
  fi

  echo
  echo "Moving to DVM folder..."
  cd "$HOME/telliot-feeds/disputable-values-monitor" || { echo "Failed to change directory."; exit 1; }

  echo
  echo "Installing DVM"
  pip install -e .
fi  

echo
echo "╔══════════════════════════════════════════════════════════════════════════╗"
echo "║Installation complete! Confirm you're inside venv before running anything.║"
if [ "$dvm" = "yes" ]; then
  echo "║                           To run the DVM:                                ║"
  echo "║Always run 'source vars.sh' from DVM folder to load the Discord variables ║"
fi
echo "╚══════════════════════════════════════════════════════════════════════════╝"
exit 0
