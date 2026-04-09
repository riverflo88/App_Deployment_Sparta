# Guide to deploymemt of app
I have previously documented how to spin an instance

For our app to run, we need these dependencies:
1. Nginx 
2. App Code
3. linux(Ubuntu)
4. NodeJs 20.x

## Copy code from local machine to remote

- copy the script provided 
``` bash
#!/bin/bash

#update package list
sudo apt update -y

echo 'update done'

#upgrade installed packages
sudo apt upgrade -y

echo 'upgrade done'

#install nginx webserver
sudo apt install nginx -y

echo 'nginx installed'

#restart nginx service - ensure nginx is running and implement any config changes

sudo systemctl restart nginx

echo 'nginx restarted'

#enable nginx service to start on boot
   
sudo systemctl enable nginx

echo 'nginx added to boot startup'

```

## Run script / Install Nginx 

- on the remote instance do

    `sudo nano deploy-nginx.sh`

- right click and paste the script using  ^C

- save file using ^S

- exit the file using ^X

- run the deploy-nginx.sh script

    `source deploy-nginx.sh`

- after running the script, check if ngnix is running

    `systemctl status nginx`

the script installs nginx

## Copying code from local/github to instance
- send the app as unzip file to remote 
  1. using secure copy
    ```
    scp -i <pem key location> <source@local-machine> <destination-remote-machine>

    scp -i ~/.ssh/se-emeka-key.pem ~/App_Deployment_Sparta/nodejs20-se-test-app-2025.zip ubuntu@ec2-54-216-215-193.eu-west-1.compute.amazonaws.com:~

    ```
    or

  2. send the file to your git
    -on the folder containing the zip file
    ```bash
        -git init
        -git add . 
        -git commit -m "pushing app-code-zipped"
        -git remote add origin <add github account>

    ```

    then go to github acccount  and  create a new empty repository. In GitHub, click the plus button at the top and select “New repository.” This time, only enter a name and a description. We want the directory to be completely blank. call the repo  App_Deployment_Sparta.

    * Click the green “Create repository” button.

    After your repository is created, go back to your git bash or terminal on the local machine and enter the folder you want to push to github

     `git push origin <branch>`
    
    Now the file is in github

    First, locate the file on GitHub,  right click raw and copy the link address, then run this command on the instance terminal: 

    `sudo wget  <paste the copied git link here>` 

    or 

    `wget -O <app-code> <URL>`

    -o: Specifies the local filename to save as.


## Unzipping the zipped app file (our app code)

Install the unzip app

`sudo apt install unzip -y`

comfirm download

`unzip --version`

Unzip file 

`sudo unzip app-code.zip`

 
## Install nodejs 20.x 
To install a specific version of nodejs

```bash

sudo apt-get install -y curl
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nsolid
nsolid -v

```
this is from node js website



## Update and upgrade

`sudo apt update -y`

`sudo apt upgrade -y`

## Install app (app code)

Explore the unzipped file (app code) until you are in the folder containing app.js (/app)

you do need to have Node.js and npm installed to run the app. But we need  to first refresh the local package index (we have just done this by doing sudo apt upgrade)

Then install Node.js:

`sudo apt install nodejs -y`

Check that the install was successful by querying node for its version number:

`node -v`

let's install npm, the Node.js package manager.This allows you to install modules and packages to use with Node.js.

`sudo install npm` 

## Start app

then run the app now

`sudo npm start app.js &`


Adding an ampersand (&) to the end of your command pushes the process to the background, immediately returning control of the terminal to you.


# How to implement a basic Reverse Proxy for the  App

The app runs from port 3000. we don't want our user to type :3000 after the website and we want to reduce inbound ports. To achieve this we do reverse proxy, this sits infront of our server and directs traffic.

we need to edit the script in ngnix to achieve this.
which is located at the ngnix config folder:
/etc/ngnix/sites-available. There is a file by name  default, we need to aceess the file and edit it.

`sudo nano default `

At the location block, replace try_files $uri $uri/ =404; with t 

`proxy_pass http://127.0.0.0:3000;`

### Restart  nginx

`sudo systemctl restart nginx`

### Restart app.js (app code)

`npm start app.js`

## Scripting the reverse proxy step
Use this script 

```bash

#!/bin/bash

#To substitute use



sudo sed -i 's|try_files $uri $uri/ =404;|proxy_pass http://127.0.0.1:3000;|' /etc/nginx/sites-available/default

# | was used as a delimiter because content has / so it could confuse sed

echo 'reverse proxy created'

# Restart  ngnix

sudo systemctl restart nginx

echo 'restarted nginx...'

# Restart app.js (app code)

npm start app.js

echo 'restarted app code...'

```

## script to deploy spartan app

```bash
#!/bin/bash/

#download the zipped app code
curl -L -o <app-code.zip>  <github-link>

#unzip
sudo apt install unzip -y`

#comfirm download
echo 'Unzip download successful'

unzip --version

#Unzip file 

unzip app-code.zip

echo 'app code unzipped'
# resfresh local package index

sudo apt update -y

sudo apt upgrade -y

# Install app (app code)
#install Node.js

sudo apt install nodejs -y


node -v

echo 'nodejs installed succcessfully'


sudo npm install -y

## Start app

sudo npm start app.js &
```
### References

https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-ubuntu-20-04

https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-ubuntu-22-04

https://nodesource.com/products/distributions


https://www.digitalocean.com/community/tutorials/linux-sed-command