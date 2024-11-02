#!/bin/bash

# Update and upgrade the system
sudo apt update && sudo apt upgrade -y

# Install necessary packages
sudo apt install -y wine xorg xfce4 xfce4-goodies xrdp novnc

# Enable and start xrdp service
sudo systemctl enable xrdp
sudo systemctl start xrdp

# Set up xfce4 as the default session for xrdp
echo xfce4-session > ~/.xsession

# Set up and start noVNC
sudo mkdir /usr/share/novnc
sudo wget https://github.com/novnc/noVNC/archive/refs/tags/v1.2.0.tar.gz -O /usr/share/novnc/novnc.tar.gz
sudo tar -xvf /usr/share/novnc/novnc.tar.gz -C /usr/share/novnc --strip-components=1
sudo ln -s /usr/share/novnc/vnc.html /usr/share/novnc/index.html

# Create a systemd service for noVNC
cat <<EOF | sudo tee /etc/systemd/system/novnc.service
[Unit]
Description=noVNC
After=network.target

[Service]
ExecStart=/usr/share/novnc/utils/launch.sh --vnc localhost:5901 --listen 6080
User=www-data
Group=www-data
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Enable and start noVNC service
sudo systemctl enable novnc
sudo systemctl start novnc

# Download and install MetaTrader 5
wget https://download.mql5.com/cdn/web/metaquotes.software.corp/mt5/mt5setup.exe -O ~/mt5setup.exe
wine ~/mt5setup.exe

echo "Setup complete. You can now access your server using RDP or noVNC."
