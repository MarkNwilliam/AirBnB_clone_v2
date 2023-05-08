#!/usr/bin/env bash
# Sets up web servers for the deployment of web_static

# Update and install nginx
sudo apt-get update
sudo apt-get -y install nginx

# Create directories
sudo mkdir -p /data/web_static/releases/test
sudo mkdir -p /data/web_static/shared

# Create fake HTML file
echo "<html><head></head><body>Holberton School</body></html>" | sudo tee /data/web_static/releases/test/index.html

# Symbolic link
sudo ln -sf /data/web_static/releases/test/ /data/web_static/current

# Permissions
sudo chown -R ubuntu:ubuntu /data/
sudo chmod -R 755 /data/

# Configure nginx
sudo sed -i '37i\\tlocation /hbnb_static {\n\t\talias /data/web_static/current/;\n\t}' /etc/nginx/sites-available/default

# Restart nginx
sudo service nginx restart
