#!/bin/bash


##### ASK ROOT PASSWORD FOR ORANGEPI BOARDS (must be identical on all board to autoinstall board 2-8 using ssh)
echo "In order PowerOff all boards 1-8 automatically, we need to login via SSH. Please make sure the root password is the same on all boards!"
# read password twice
read -sp "Please enter root password: " RootPassword

##### This must be there so terminal creates a new line after password entry!!!
echo

##### AUTO INSTALL SKYMINER SOFTWARE ON ORANGEPI'S 2-8 VIA SSH
echo "Powering down all skywire servers."

poweroff()
{
  sshpass -p $RootPassword ssh pi@192.168.178.$1 << EOF
  sudo poweroff
  EOF
}
for i in 192.168.178.{102..108}; do poweroff $i; done

###### Clear root password variable
unset $RootPassword

##### SUCCESSFUL INSTALLATION NOTIFICATION
echo "All skywire server have been powered down"