#!/bin/bash
 
#######################################################################################################################################################################
#######################################################################################################################################################################
##### SKYMINER (SKYCOIN) ORANGE PI AUTO INSTALL SCRIPT
##### This script automatically installs the full Skycoin and Skywire software including all dependencies with one push of a button on all Raspberry PI boards.
##### To run this script type "sh SkyInstallScriptStart.sh" into a terminal and hit enter! 
##### For more detailed instructions please consult our tutorial.
##### For further assistence feel free to contact us! 
#######################################################################################################################################################################
##### Version:		1.0  - Get the newest version at https://github.com/dobby/SkyInstallScript
#######################################################################################################################################################################
##### Team:			       The SKYpeople (Email: TheSKYpeople@protonmail.com - Telegram: @TheSKYpeople)
##### Licence:		     GNU General Public License v3.0
##### Donations:	    Skycoin      zrwaGKR8oG7juYLHqgj7zwxH4bGYPEwWTB
#####				            Ethereum     0x25a4cc8003a626e0b1d0be4626dc33e82a0096a0
#####				            Bitcoin 	    1EH9Sw1JgnndJGVnUsQkhhiA6XBynqUFuQ
#######################################################################################################################################################################
#######################################################################################################################################################################

#######################################################################################################################################################################
#######################################################################################################################################################################
 
 

#######################################################################################################################################################################
#######################################################################################################################################################################
###### DON'T CHANGE ANYTHING BELOW THIS LINE (IF YOU DON'T KNOW WHAT YOU ARE DOING)!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#######################################################################################################################################################################
#######################################################################################################################################################################


 
##### UPDATING RESPOSITORY & UPGRADING OS
echo "Updating respository and perfoming OS upgrade right now..."
sudo apt-get update && sudo apt-get upgrade -y
echo "Repository Update and OS Upgrade succesfully done!"
 
 
##### INSTALL DEPENDECIES FOR GO
echo "Installing GO dependencies right now..."
sudo apt-get install -y curl git mercurial make binutils gcc bzr bison libgmp3-dev screen build-essential
echo "GO ependencies succesfully installed!"
 
##### INSTALL GO LIBRARY
echo "Installing GO right now..."

echo "first removing old go version from the system"
sudo apt-get remove golang
sudo apt autoremove
#Remove any old go installations
sudo rm -rf /usr/local/go/

###### Downloading GO source from Google servers using CURL
sudo wget https://storage.googleapis.com/golang/go1.10.2.linux-armv6l.tar.gz

###### Unzip the compressed GO source files
sudo tar -C /usr/local -xzf go1.10.2.linux-armv6l.tar.gz

###### Remove the downloaded compressed file (not needed anylonger!)
sudo rm go1.10.2.linux-armv6l.tar.gz

###### Configure go enviroment variable
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.profile

###### Reload the paths
source ~/.profile

###### Create GO directories
mkdir -p $HOME/go
mkdir -p $HOME/go/bin
mkdir -p $HOME/go/src
mkdir -p $HOME/go/pkg

###### Move GO folder
sudo mv go /usr/local/go

###### Create GO links
sudo ln -s /usr/local/go/bin/go /usr/local/bin/go
sudo ln -s /usr/local/go/bin/godoc /usr/local/bin/godoc
sudo ln -s /usr/local/go/bin/gofmt /usr/local/bin/gofmt

###### Return to root folder
cd ~

###### Configure $GOPATH variables
echo 'export GOROOT=/usr/local/go' >> ~/.bashrc
echo 'export GOPATH=$HOME/go' >> ~/.bashrc
echo 'export GOBIN=$GOPATH/bin' >> ~/.bashrc
echo 'export PATH=$PATH:$GOBIN' >> ~/.bashrc

###### Reload GO paths
. ~/.bashrc
echo "GO succesfully installed!"
 
echo "Installing git"
sudo apt-get install git

##### INSTALL SKYWIRE
echo "Installing Skywire right now..."

mkdir -p $GOPATH/src/github.com/skycoin

###### Change the path for download
cd $GOPATH/src/github.com/skycoin
###### Obtain Skywire source files from Github using GIT
git clone https://github.com/skycoin/skywire.git
###### Chaning into installation path
cd $GOPATH/src/github.com/skycoin/skywire/cmd
###### Run Skywire installation
go install ./...
echo "Skywire succesfully installed!"

##### Now Lauching Skywire
echo "Now lauching Skywire"
cd $GOPATH/bin
./manager -web-dir ${GOPATH}/src/github.com/skycoin/skywire/static/skywire-manager > /dev/null 2>&1 &
echo "Skywire is now running in the background. You can now access the Skywire Manager via the web browser" 
sleep 5


##### START SKYWIRE MONITOR
###### Change into installation path
cd $GOPATH/bin
###### Starts Skywire Monitor service for the first time / after that command web interface of Monitor works
###### This line is to start the monitor on the master node (Raspberry PI 1) only / Other Orange PIs requiere a different line with the master nodes IP!!!
./node -connect-manager -manager-address :5998 -manager-web :8000 -discovery-address messenger.skycoin.net:5999 -address :5000 -web-port :6001 &> /dev/null 2>&1 &
echo "Skywire monitor started." 
echo "You can now open the monitor in your browser: http://192.168.178.101:8000"
sleep 10


##### START SCRIPTS / STOP SCRIPTS
###### Download start / stop scripts
echo "Downloading autostart scripts from TheSKYpeople Github" 
cd ~
wget https://raw.githubusercontent.com/dobby/SkyInstallScript/master/ServiceStartSkywirePrimary.sh
wget https://raw.githubusercontent.com/dobby/SkyInstallScript/master/ServiceStopSkywire.sh

##### Executing InstallScript Part 2 (SkyInstallScriptRemote.sh) for installation of Raspberry PI 2-8 via SSH
###### Downloading Part 2
cd ~
wget https://raw.githubusercontent.com/dobby/SkyInstallScript/master/SkyInstallScriptRemote.sh
###### Changing permissions 
chmod 755 SkyInstallScriptRemote.sh
###### Execute Part 2
./SkyInstallScriptRemote.sh









