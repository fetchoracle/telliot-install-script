#!/bin/bash

# Check if the directory already exists
if [ -d "$HOME/telliot-feeds" ]; then
  echo "The folder 'telliot-feeds' already exists. Please remove or rename it to save old configs."
  exit 1
fi

echo 
echo "      ╔═════════════════════════════════════════════════════════════════╗"
echo "      ║ This script will install Python, Telliot-feeds and Telliot-core ║" 
echo "      ║       (Optionally you can also choose to install the DVM)       ║"
echo "      ╚═════════════════════════════════════════════════════════════════╝"
echo "If installing in your main machine, please read the install.sh before install!"
echo "Note: You may need to give authorization for updates and Python during install."
echo
cd "$HOME/"
echo "Choose the environment to clone and install: "
echo "1 - Mainnet (Default production)"
echo "2 - Testnet (Testnet)"
echo "3 - Staging (QA tests only)"
echo
read -p "Enter 1-mainnet, 2-testnet or 3-staging: " environment_choice

case $environment_choice in
  1)
    branch="main"
    ;;
  2)
    branch="testnet"
    ;;
  3)
    branch="staging"
    ;;
  "")
    branch="main"
    ;;
  *)
    echo "Invalid choice. Please enter 1 for mainnet, 2 for testnet or 3 for staging."
    exit 1
    ;;
esac
echo "You entered: $branch"
sleep 1
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
sleep 2
echo

echo updating system... apt-get, apt and git update.
sleep 3
sudo apt update
sudo apt-get update
sudo apt install git

# Clone the repository with the selected branch
echo "Cloning telliot-feeds..."
sleep 2
git clone -b "$branch" https://github.com/fetchoracle/telliot-feeds.git

if [ $? -eq 0 ]; then
  echo "Telliot-feeds cloned successfully."
  sleep 2
else
  echo "Failed to clone telliot-feeds."
  exit 1
fi

echo
echo "Moving to telliot-feeds folder..."
sleep 2
cd "$HOME/telliot-feeds" || { echo "Failed to change directory. Make sure to install it from HOME."; exit 1; }

echo
echo "Installing Python 3.9 and venv..."
sleep 2

current_distro=""
if command -v lsb_release &> /dev/null; then
    current_distro=$(lsb_release -d | cut -f2)
else
    echo "lsb_release command not found"
fi
echo "Current Distro Version: $current_distro"

supported_distros=("Ubuntu" "Debian")
supported_releases_ubuntu=("24.04" "22.04")
supported_releases_debian=("11")

current_distro_id=$(lsb_release -i | cut -f2)
current_distro_release=$(lsb_release -r | cut -f2)

found=false
for distro in "${supported_distros[@]}"; do
    if [[ "$current_distro_id" != "$distro" ]]; then
        continue
    fi

    if [[ "$distro" == "Ubuntu" ]]; then
        for release in "${supported_releases_ubuntu[@]}"; do
            if [[ "$current_distro_release" == "$release" ]]; then
                found=true
                break
            fi
        done
    fi

    if [[ "$distro" == "Debian" ]]; then
        for release in "${supported_releases_debian[@]}"; do
            if [[ "$current_distro_release" == "$release" ]]; then
                found=true
                break
            fi
        done
    fi

    if [[ "$found" == "true" ]]; then
        break
    fi
done

if [[ $current_distro != "" && "$found" == "false" ]]; then
    echo "Current distribution is NOT in the list."
    echo "Supported distributions and releases are:"
    echo "Ubuntu: ${supported_releases_ubuntu[*]}"
    echo "Debian: ${supported_releases_debian[*]}"
    exit 1
fi

echo "Intalling python3.9 through deadsnakes PPA repository"
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt install -y python3.9 python3.9-venv #python3-pip

# Create and activate the virtual environment
echo
echo "Creating and entering virtual environment..."
sleep 2
python3.9 -m venv venv
source venv/bin/activate

echo
echo "Installing telliot feeds"
sleep 2
pip install -e .
echo
echo "Creating copy of .env.example"
sleep 2
cp .env.example .env
if [ -f .env ]; then
    echo ".env created successfully."
    sleep 2
else
    echo "Failed to create .env."
    echo "Please, check telliot-feeds folder and rename .env.example to .env manually"
    sleep 3
fi

echo
echo "Cloning telliot-core..."
sleep 2
git clone -b "$branch" https://github.com/fetchoracle/telliot-core.git

if [ $? -eq 0 ]; then
  echo "Telliot-core cloned successfully."
  sleep 2
else
  echo "Failed to clone telliot-core."
  exit 1
fi

echo
echo "Moving to telliot-core folder..."
sleep 2
cd "$HOME/telliot-feeds/telliot-core" || { echo "Failed to change directory."; exit 1; }

echo
echo "Installing telliot core"
sleep 2
pip install -e .
telliot config init

cd "$HOME/telliot-feeds/" || { echo "Failed to change directory."; exit 1; }

if [ "$dvm" = "yes" ]; then
  echo
  echo "Cloning DVM..."
  sleep 2
  git clone -b "$branch" https://github.com/fetchoracle/disputable-values-monitor.git

  if [ $? -eq 0 ]; then
    echo "DVM cloned successfully."
    sleep 2
  else
    echo "Failed to clone DVM."
    exit 1
  fi

  echo
  echo "Moving to DVM folder..."
  sleep 2
  cd "$HOME/telliot-feeds/disputable-values-monitor" || { echo "Failed to change directory."; exit 1; }

  echo
  echo "Installing DVM"
  sleep 2
  pip install -e .
fi  

echo
echo "      ╔════════════════════════════════════════════════════════════╗"
echo -e "      ║                   \e[1mInstallation complete!\e[0m                   ║"
echo "      ║         Telliot guide: https://tinyurl.com/mryzpw9v        ║"
if [ "$dvm" = "yes" ]; then
  echo "      ║           DVM guide: https://tinyurl.com/bdey7ph9          ║"
fi
echo "      ╚════════════════════════════════════════════════════════════╝"
exit 0