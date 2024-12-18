#!/bin/bash

  sudo add-apt-repository universe -y
  sudo add-apt-repository ppa:agornostal/ulauncher -y

  echo "Updating repositories..."
  sudo apt update -y

  #gsettings set org.gnome.desktop.interface enable-animations false
  gsettings set org.gnome.nautilus.preferences default-sort-order 'type'
  gsettings set org.gnome.nautilus.preferences show-hidden-files true
  gsettings set org.gnome.nautilus.icon-view default-zoom-level 'small'

  
  apt_programs=(
    neofetch
    net-tools
    tree
    ulauncher
  )

  snap_programs=(
    "btop"
    "discord"
    "libreoffice"
    "nordpass"
    "notion-snap-reborn"
    "spotify"
    "thunderbird"
    #"fast"
    #"anki-ppd"
    #"buka"
    #"deckboard"
    #"insomnia"
    #"postman"
    #"ludo"
    #"telegram-cli"
    #"termius-app"
    #"weka"
  )

  echo "Installing APT packages..."
  for apt_program in "${apt_programs[@]}"; do
    sudo apt install "$apt_program" -y
  done
  
  snap refresh

  echo "Installing SNAP packages..."
  sudo snap install code --classic
  sudo snap install obsidian --classic
  sudo snap install sublime-text --classic
  
  for snap_program in "${snap_programs[@]}"; do
    sudo snap install "$snap_program"
  done
  
  snap connect nordpass:password-manager-service

  echo "Installing Google Chrome..."
  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  sudo dpkg -i ./google-chrome-stable_current_amd64.deb
  rm google-chrome-stable_current_amd64.deb

  echo "Installing Jetbrains Toolbox..."
  wget https://download.jetbrains.com/toolbox/jetbrains-toolbox-2.5.2.35332.tar.gz

  echo "Installing Docker"
  sudo apt install ca-certificates curl
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc
  echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt update
  sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

  echo "Installing Ollama..."
  curl -fsSL https://ollama.com/install.sh | sh
  ollama run llama3.2:3b

  echo "Configuring Git..."
  git config --global credential.helper store
  git config --global user.email eu@raulpacheco.com.br
  git config --global user.name raulpacheco2k

  echo "Finalizing, updating and cleaning "
  sudo apt update -y
  sudo apt dist-upgrade -y
  sudo apt autoclean -y
  sudo apt autoremove -y

  echo "Process finished, press enter..."
  read enter

  read -p "Do you want to restart your computer now? [Y/N]: " option
  if [ "$option" == "y" ] || [ "$option" == "Y" ]; then
    sudo reboot
  fi

  exit 0
