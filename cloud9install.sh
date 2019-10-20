#!/bin/bash
#
cd
clear

echo " "
echo "*****************************************************"
echo " This script will set up a cloud9 IDE  on your target server"
echo "-----------------------------------------------------"
echo "Please enter the data path you would like to use to access Cloud9?"
echo "****************************************************************"
read wd

sudo apt update
#apt-get upgrade -y

clear

echo " "
echo "***************************************************************"
echo "INSTALLING CLOUD9"
echo "---------------------------------------------------------------"

sudo apt-get install curl software-properties-common tmux -y

curl -sL https://deb.nodesource.com/setup_10.x | sudo bash -

export LANG=en_US.UTF-8
export LANGUAGE=en:el

sudo apt install git nodejs -y

git clone https://github.com/c9/core.git c9sdk

cd c9sdk

sudo ./scripts/install-sdk.sh

echo " "
echo "***************************************************************"
echo "INSTALLING CLOUD9-DAEMON"
echo "---------------------------------------------------------------"

cat <<EOF >> /etc/init.d/cloud9-daemon
#!/bin/bash
### BEGIN INIT INFO
# Provides:          cloud9
# Description:       A simple script which will start / stop cloud9 at boot / shutdown.
### END INIT INFO

# If you want a command to always run, put it here

# Carry out specific functions when asked to by the system
case "$1" in
  start)
    cd /root/c9sdk
    sudo nodejs server.js -p 8181 -l 0.0.0.0 -a : -w $wd/workspace &
    #echo "Launching cloud9 with workspace root set to $wd/workspace"
    ;;
  stop)
    echo "Stopping cloud9"
    # kill application you want to stop
    pkill -f "node ./server.js"
    ;;
  *)
    echo "Usage: /etc/init.d/cloud9 {start|stop}"
    exit 1
    ;;
esac
EOF

sudo chmod 755 /etc/init.d/cloud9-daemon
sudo update-rc.d cloud9-daemon defaults
sudo mkdir -p $wd/workspace

clear

echo " "
echo "*****************************************************"
echo "THE INSTALLATION HAS FINSIHED"
echo "-----------------------------------------------------"
echo " "
echo " Please browse to your IP:8181 in your browser to access cloud9"
echo " "
echo "**************************************************************************************************************"
