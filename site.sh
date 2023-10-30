#!/bin/bash


# Check if the server name is provided as an argument
if [ $# -lt 1 ]; then
    echo "Usage: $0 <server_name>"
    exit 1
fi

# Check apt pakage managers
install_with_apt() {
  sudo apt update
  sudo apt install -y certbot python3-certbot-nginx
}

# Check yum pakage manager
install_with_yum() {
  sudo yum update
  sudo yum install epel-release -y
  sudo yum install -y certbot python3-certbot-nginx
}

#Detect the package manager
install_software() {
  local software_name="$package"
  
  # Check if APT is available
  if command -v apt > /dev/null; then
    install_with_apt "$software_name"
  # Check if YUM is available
  elif command -v yum > /dev/null; then
    install_with_yum "$software_name"
  else
    echo "Package manager not-found. Cannot install software."
  fi
}
install_software "package_name"
# Assign the server name from the argument
server_name="$1"
nginx_conf_dir="/etc/nginx/sites-available"
nginx_conf_file="${server_name}"

# Create an Nginx site configuration file
cat <<EOF > "${nginx_conf_dir}/${nginx_conf_file}"
server {
    listen 80;
    server_name ${server_name};
    
    location / {
        add_header Access-Control-Allow-Origin *;
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header Upgrade \$http_upgrade;
    }
}
EOF

# Create a symlink to enable the site
sudo ln -s "${nginx_conf_dir}/${nginx_conf_file}" "/etc/nginx/sites-enabled/"

# Reload Nginx to apply the new configuration
sudo systemctl restart nginx.service

# Use Certbot to obtain an SSL certificate
sudo certbot --nginx -d "${server_name}"

# Reload Nginx to enable SSL
sudo systemctl restart nginx.service

echo "Nginx site configuration created, and SSL certificate added for ${server_name}"
