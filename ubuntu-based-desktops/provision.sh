#!/bin/sh
set -e

# Run script as none root - ./provision.sh

sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y software-properties-common apt-transport-https wget curl
sudo add-apt-repository ppa:ondrej/php -y
sudo apt-get update

# install PHP, Mysql and redis
sudo apt install unzip zsh  git php7.4 php7.4-mysql php7.4-xml php7.4-gd php7.4-zip php7.4-mbstring php7.4-redis php7.4-curl mariadb-server redis-server uidmap -y
sudo apt-get purge apache2 -y # using docker instead

# install VScode and edge
sudo wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository -y "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main"
sudo add-apt-repository -y "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"

sudo apt update -y
sudo apt install -y microsoft-edge-stable code

# Install VScode extensions
reset
code --install-extension walkme.PHP-extension-pack
code --install-extension rifi2k.format-html-in-php
code --install-extension esbenp.prettier-vscode
code --install-extension small.php-ci
code --install-extension jawandarajbir.react-vscode-extension-pack
code --install-extension johnpapa.vscode-peacock
code --install-extension TabNine.tabnine-vscode
code --install-extension ms-azuretools.vscode-docker

# Sublime text
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt update -y
sudo apt install -y sublime-text

## install NVM ##
cd /tmp
curl -sL https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.0/install.sh -o install_nvm.sh
chmod +x install_nvm.sh
./install_nvm.sh

export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

nvm install --lts

## install docker ##

curl -sL https://get.docker.com/ -o install_docker.sh
chmod +x install_docker.sh
sudo bash install_docker.sh
dockerd-rootless-setuptool.sh install

sudo groupadd docker
sudo usermod -aG docker $USER

sudo systemctl enable docker.service
sudo systemctl enable containerd.service


# Postman ##
mkdir /home/$USER/Applications
cd /home/$USER/Applications
curl -sL https://github.com/suciptoid/postman-appimage/releases/download/continous/Postman-9.9.3-x86_64.AppImage -o Postman
chmod +x Postman
cd /usr/local/bin && sudo ln -s /home/$USER/Applications/Postman
cd /home/$USER/

# MYSQL user ###
sudo systemctl start mysql
sudo mysql -e "create user $USER@localhost identified by '1234';"
sudo mysql -e "GRANT ALL PRIVILEGES ON *.* TO $USER@localhost;"
sudo mysql -e "FLUSH PRIVILEGES;"

## cuda drivers -- install nvida drivers first
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pinsudo 
mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/11.7.0/local_installers/cuda-repo-ubuntu2004-11-7-local_11.7.0-515.43.04-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu2004-11-7-local_11.7.0-515.43.04-1_amd64.debsudo 
cp /var/cuda-repo-ubuntu2004-11-7-local/cuda-*-keyring.gpg /usr/share/keyrings/sudo 
apt-get updatesudo apt-get -y install cuda

## Prettify default terminal ##

# Terminal fonts for starship
cd /tmp
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/3270.zip
mkdir nerd && cd nerd && unzip ../3270.zip
cd /tmp
sudo mv nerd /usr/share/fonts/truetype/
sudo fc-cache -f -v
rm -rf 3270.zip

cd /tmp
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
curl -sS https://starship.rs/install.sh -o install_starship.sh
chmod +x install_starship.sh
./install_starship.sh

# generate ssh keys
ssh-keygen -f /home/$USER/.ssh/id_rsa

# Timshift
sudo apt install -y timeshift
sudo timeshift --create --rsync --yes --verbose --scripted
