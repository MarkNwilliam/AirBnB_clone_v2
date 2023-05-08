#!/usr/bin/env bash

# Install nginx if not already installed
if [ ! $(which nginx) ]; then
  sudo apt-get -y update
  sudo apt-get -y install nginx
fi

# Create necessary directories
sudo mkdir -p /data/web_static/releases/test
sudo mkdir -p /data/web_static/shared

# Create fake HTML file
echo "<html><head></head><body>Holberton School</body></html>" | sudo tee /data/web_static/releases/test/index.html

# Create symbolic link
if [ -L /data/web_static/current ]; then
  sudo rm /data/web_static/current
fi
sudo ln -sf /data/web_static/releases/test /data/web_static/current

# Change ownership of /data/ to ubuntu user and group
sudo chown -R ubuntu:ubuntu /data/

# Update Nginx configuration
sudo sed -i 's|^\tserver_name localhost;|&\n\n\tlocation /hbnb_static/ {\n\t\talias /data/web_static/current/;\n\t}\n|' /etc/nginx/sites-available/default

# Restart Nginx
sudo service nginx restart

~
