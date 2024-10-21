Telliot-Alt version help installer for Tellor's Telliot on Pulsechain.
This script will clone and install telliot-feeds-alt, telliot-core-alt and, optionally, the disputable-values-monitor-alt.

!If you're installing in your main machine, please, read the install.sh before installing!

Recommended to install in a Linux Virtual Machine with linux bash(Ubuntu, for example). 
Copy and paste the line below in your terminal and run it:

curl -O https://raw.githubusercontent.com/fetchoracle/telliot-install-script-alt/refs/heads/main/install.sh && chmod +x install.sh && ./install.sh && cd telliot-feeds-alt && source venv/bin/activate

Note:
Everytime you need to run Telliot or DVM, you need to enter the venv environment from inside the telliot feeds folder: source/venv/bin/activate

To run the DVM, go to DVM folder and run 'source vars.sh' to load Discord variables before running the 'cli' commmand.
