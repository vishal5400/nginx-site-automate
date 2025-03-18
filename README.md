# nginx-site-automate
This Bash script automates the process of hosting a website with SSL (Secure Sockets Layer) using the Nginx web server and the Certbot tool. It streamlines the setup and configuration of SSL certificates, making it easy to secure your website and enable encrypted connections.
1. Install Nginx and Certbot (if not already installed) on your Linux server.
2. Configures Nginx to host your website, setting up server blocks and virtual hosts.
3. Uses Certbot to automatically obtain SSL certificates from Let's Encrypt.

## Steps to Run the Script:
#### 1. Clone the Repository
#### 2. Grant Execute Permission to the Script
  ```bash
  chmod +x site.sh
  ```
#### 3. Run the Script with a Domain Name
   ```bash
   ./site.sh domain
   ```
Replace domain.com with the actual domain you wish to use.
