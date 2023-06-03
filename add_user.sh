#!/bin/bash

# usage: add_user.sh [userName]

if [ -z "$1" ]; then
  echo "Mandatory parameter absent!!!"
  echo
  echo "Script will add new user to docker group if exists."
  echo "If started with root rights (sudo ./add_user.sh ...), will add feature Sudo without password for new user"  
  echo "Example of using: ./add_user.sh <userName>"
  exit 1
fi

NEW_USER=$1
current_user="$USER"

echo
echo -e "Current user $current_user"
echo -e "Adding new user $NEW_USER"
echo

sudo adduser $NEW_USER
sudo usermod -G sudo $NEW_USER

if getent group docker >/dev/null; then
  sudo usermod -aG docker $NEW_USER
  echo "Added to docker's group."
else
  echo "docker's group doesn't exists!!!"
fi

####################################
# Adding authorized_keys to new user
####################################
sudo mkdir /home/$NEW_USER/.ssh
key_file_path="$HOME/.ssh/authorized_keys"

if [ -e "$key_file_path" ]; then
	sudo cp $key_file_path /home/$NEW_USER/.ssh/
else
	echo "authorized_keys for user $current_user doesn't exists!!!"

	key_file_path="/root/.ssh/authorized_keys"
	if [ -e "$key_file_path" ]; then
		sudo cp $key_file_path /home/$NEW_USER/.ssh/
	else
		echo "authorized_keys for user root doesn't exists!!!"
	fi  
fi

sudo chown -R $NEW_USER:$NEW_USER /home/$NEW_USER/.ssh/

if [ current_user == 'root' ]; then
	sudo echo "$NEW_USER  ALL=NOPASSWD: ALL" >> /etc/sudoers
	  echo "Sudo without password enabled"
fi

echo "User $NEW_USER added"
