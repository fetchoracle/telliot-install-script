Telliot installer script for Tellor's Telliot on Pulsechain.
This script will clone and install telliot-feeds, telliot-core and, optionally, the disputable-values-monitor.

!If you're installing in your main machine, please, read the install.sh before installing!

Recommended to install in a Linux Virtual Machine with linux bash(Ubuntu, for example). 
Copy and paste the line below in your terminal and run it:

```bash
curl -O https://raw.githubusercontent.com/fetchoracle/telliot-install-script/refs/heads/main/install.sh && chmod +x install.sh && ./install.sh && cd && cd telliot-feeds && source venv/bin/activate
```

Important Note:
Everytime you need to run Telliot or DVM, you need to enter the venv environment from inside the 'telliot feeds' folder located in $Home, running: 
source/venv/bin/activate

[Telliot instructions](https://tinyurl.com/mryzpw9v)  
[DVM instructions](https://tinyurl.com/bdey7ph9)
