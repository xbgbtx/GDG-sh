#Restarts the vbox client.  Useful when copy/paste between host and guest
#stops working
#
# Reference: https://askubuntu.com/questions/63420/how-to-fix-virtualboxs-copy-and-paste-to-host-machine

killall VBoxClient
VBoxClient-all
