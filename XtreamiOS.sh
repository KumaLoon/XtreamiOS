#!/bin/bash

if ! type "autoconf" > /dev/null; then
	echo "autoconf is not installed. Exiting..."
	echo "Use homebrew to install the tools"
	exit
elif ! type "automake" > /dev/null; then
	echo "automake is not installed. Exiting..."
	echo "Use homebrew to install the tools"
	exit
elif ! type "libtool" > /dev/null; then
	echo "libtool is not installed. Exiting..."
	echo "Use homebrew to install the tools"
	exit
fi

echo "Type your password"
if [[ ! $EUID -ne 0 ]]; then
echo "\n\033[1;31mEnter your user password.\033[m"
fi
sudo clear

### PRESENT MENU ###
Menu (){

clear
echo "Opensn0w by @winocm"
echo "Opensn0w macOS patch by Devbug"
echo "XtreamiOS 1.4 Script by LooneySJ"
echo "SSH tool by msftguy and SSH2_Bundle by DevTeam"
echo "Big Thanks to @pooktwitr, for helping with bug fixes"
echo ""

show_Menu () {

echo "1.  Install Opensn0w"
echo "2.  Automatic install during SSH"
echo "3.  Uninstall XtreamiOS"
echo "4.  Post installation script (install package manager)"
echo
echo "Q. Quit"

read SELECT

case "$SELECT" in

# Install Opensn0w and mkdir for it
1)
sudo rm -rf ~/iOS7tethered
mkdir ~/iOS7tethered
mkdir ~/iOS7tethered/BU
cp 7.1.zip ~/iOS7tethered
cd ~/iOS7tethered
unzip 7.1.zip
chmod +x 7.1/bin/tar
chmod +x 7.1/bin/gzip
rm -rf 7.1.zip

git clone https://github.com/Malvix/opensn0w #original link is down
cd opensn0w
if [[ "$OSTYPE" == "darwin"* ]]; then
	patch -p1 < opensn0w3.diff
fi
sudo rm -rf /usr/local/opensn0w
chmod +x autogen.sh
chmod +x configure
./autogen.sh
./configure
sudo make
sudo make install
;;

2)
echo "Opening SSH client"
open ~/iOS7tethered/7.1/ssh_rd_rev04b.jar &
echo "Waiting for system to catch up…"
sleep 10s
echo "Backing up known_hosts (known_hosts.bak)"
sleep 2s
sudo mv ~/.ssh/known_hosts ~/.ssh/known_hosts.bak

expect -c"
spawn ssh root@localhost -p 2022 -o StrictHostKeyChecking=no
expect \"root@localhost's password:\"
send \"alpine\r\"
expect \"sh-4.0#\"
send \"mount.sh\r\"
expect \"sh-4.0#\"
send \"exit\r\"
expect \"closed.\"
"

echo "Please wait, System Processing"
sleep 5s
cd ~/iOS7tethered/7.1/
expect -c"
spawn scp -P 2022 bin/tar bin/gzip root@localhost:/mnt1/bin
expect \"root@localhost's password:\"
send \"alpine\r\"
expect \"dummy expect\"
"

expect -c"
spawn scp -P 2022 bin/tar bin/gzip root@localhost:/bin
expect \"root@localhost's password:\"
send \"alpine\r\"
expect \"dummy expect\"
"

expect -c"
spawn scp -P 2022 SSH2_bundle.tgz root@localhost:/mnt1/
expect \"root@localhost's password:\"
send \"alpine\r\"
expect \"dummy expect\"
"

expect -c"
spawn scp -P 2022 fstab root@localhost:/mnt1/etc/
expect \"root@localhost's password:\"
send \"alpine\r\"
expect \"dummy expect\"
"

expect -c"
spawn scp -P 2022 Services.plist root@localhost:/mnt1/System/Library/Lockdown/
expect \"root@localhost's password:\"
send \"alpine\r\"
expect \"dummy expect\"
"

expect -c"
spawn scp -P 2022 lib.tgz root@localhost:/mnt2
expect \"root@localhost's password:\"
send \"alpine\r\"
expect \"dummy expect\"
"

expect -c"
spawn scp -P 2022 cy.tgz root@localhost:/mnt2/mobile
expect \"root@localhost's password:\"
send \"alpine\r\"
expect \"dummy expect\"
"

expect -c"
spawn ssh root@localhost -p 2022
expect \"root@localhost's password:\"
send \"alpine\r\"
expect \"sh-4.0#\"
send \"cd /mnt1\r\"
expect \"sh-4.0#\"
send \"tar xzpf SSH2_bundle.tgz\r\"
expect \"sh-4.0#\"
send \"rm SSH2_bundle.tgz\r\"
expect \"sh-4.0#\"
send \"cd /mnt2\r\"
expect \"sh-4.0#\"
send \"tar xzpf lib.tgz\r\"
expect \"sh-4.0#\"
send \"rm lib.tgz\r\"
expect \"sh-4.0#\"
send \"cd /mnt2/mobile\r\"
expect \"sh-4.0#\"
send \"tar xzpf cy.tgz\r\"
expect \"sh-4.0#\"
send \"rm cy.tgz\r\"
expect \"sh-4.0#\"
send \"halt\r\"
expect \"sh-4.0#\"
"
sudo mv ~/.ssh/known_hosts.bak ~/.ssh/known_hosts
;;

3)
# remove
echo "Removing XtreamiOS"
sudo rm -rf ~/iOS7tethered
sudo rm -rf /usr/local/opensn0w
echo "Done"
;;

4)
read -p "Please type your iPhone’s IP address: " SSH
ssh root@$SSH -o StrictHostKeyChecking=no "mkdir /var/cache; cd /var/cache; mkdir apt; cd apt; mkdir archives; cd archives; mkdir partial; cd /var/mobile/cy; dpkg -i cydia-lproj_1.1.0_iphoneos-arm.deb; dpkg -i org.thebigboss.repo.icons_1.0.deb; dpkg -i uikittools_1.1.8_iphoneos-arm.deb; dpkg -i cydia_1.1.9_iphoneos-arm.deb; chmod 0755 /Applications/Cydia.app; chown root:admin /Applications/Cydia.app; rm /var/mobile/cy/; reboot"
;;

[Qq]) exit ;;
*)
show_Menu
;;
esac

echo
read -sn 1 -p "Press any key to continue with this tool"
Menu
}
show_Menu
}
Menu
