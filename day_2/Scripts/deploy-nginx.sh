#!/bin/bash

#update package list
sudo apt update -y

#upgrade installed packages
sudo apt upgrade -y

#install nginx webserver
sudo apt install nginx -y


#restart nginx service - ensure nginx is running and implement any config changes
sudo systemctl restart nginx

#enable nginx service to start on boot
   #make it a startup process
sudo systemctl enable nginx

