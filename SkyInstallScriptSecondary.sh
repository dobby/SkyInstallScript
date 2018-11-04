#!/bin/bash
 
#######################################################################################################################################################################
#######################################################################################################################################################################
##### SKYMINER (SKYCOIN) ORANGE PI AUTO INSTALL SCRIPT SECONDARY (FOR Raspberry PI BOARDS 2-8 ONLY!!!)
##### This script automatically installs the full Skycoin and Skywire software including all dependencies via SSH on Raspberry PI boards 2-8.
##### This script will be automatically executed by the SkyInstallScript.sh. There is no need to run this manually!
##### For more detailed instructions please consult our tutorial.
##### For further assistence feel free to contact us! 
#######################################################################################################################################################################
##### Version:		1.0  - Get the newest version at https://github.com/dobby/SkyInstallScript
#######################################################################################################################################################################
##### Team:			The SKYpeople (Email: TheSKYpeople@protonmail.com - Telegram: @TheSKYpeople)
##### Licence:		GNU General Public License v3.0
##### Donations:	Skycoin      zrwaGKR8oG7juYLHqgj7zwxH4bGYPEwWTB
#####				Ethereum     0x25a4cc8003a626e0b1d0be4626dc33e82a0096a0
#####				Bitcoin 	 1EH9Sw1JgnndJGVnUsQkhhiA6XBynqUFuQ
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
###### This line is to start the monitor on the slave nodes (Raspberry PI 2-8) only / Master Orange PIs requiere a different line!!!
./node -connect-manager -manager-address 192.168.178.101:5998 -manager-web 192.168.178.101:8000  -address :5000 -web-port :6001 > /dev/null 2>&1 &
echo "Skywire node is now started and you can see it in on the Monitor." 

##### START SCRIPTS / STOP SCRIPTS
###### Download start / stop scripts
echo "Downloading autostart scripts from TheSKYpeople Github" 
cd ~
wget https://raw.githubusercontent.com/dobby/SkyInstallScript/master/ServiceStartSkywireSecondary.sh
wget https://raw.githubusercontent.com/dobby/SkyInstallScript/master/ServiceStopSkywire.sh

 

