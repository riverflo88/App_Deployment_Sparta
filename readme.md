# Cloud Intro- Spinning up a cloud virtual machine (instance)

* Login to AWS with the right credentials
* Ensure you pick the right Region location (e.g Europe(Ireland))
* Select the cloud services - preferrably using the search bar if the service is known. Here I am going for EC2(Elastic cloud computing)
* 



## SSH and SSH Key Pairs

* You must create a key pair that helps you securely connect to the instance from your local machine
* on the Ec2 Navigation bar, go to Network and security and click Key pairs
* Click on create key pair 

  * name the key pair by following a good naming convention (e.g se-emeka-key-pair)
  * most organisation will go for RSA as the key pair type and .pem as the private key file format
* When the key pair is created and downloaded, cut the downloaded key pair file to the .ssh folder located at /user/<user\_name>/.ssh. (create a new .ssh folder if none is found ). NB .ssh file is a hidden file

## Virtual Machines



* on the EC2 navigation bar under Instances, click on instances to create a new instance
* click launch an instance 
* choose a good name for the instance(e.g se-emeka-first-instance-linux)
* choose the correct OS image(AMI)  and ensure the right instance type is selected 
  * Ubuntu 24.04 and  Instance Type = t3.micro
* Select the key pair name which has been previously created
* Edit the network setting and create a new security group(by creating add security group rule) if not present

  * ports that should be accessible must be configured here. For example, ssh and http (In inbound security group, all ports are closed by default)
  * since http is used, the source could be 0.0.0.0/0.
* Click Launch instance to spin it up.
* On the EC2 navigation bar, click on instances under instances and search for the instance , then click on it and then click connect

  * on the connect page, click on the SSH client for the info on how to access or connect to the instance via your local machine.



## Connecting to instance via local machine

* Open an SSH client.
* Locate your private key file. The key used to launch this instance is se-emeka-key-pair.pem
* Run this command, if necessary, to ensure your key is not publicly viewable

&#x20;  `chmod 400 "se-emeka-key-pair.pem"`



* Connect to your instance using its Public DNS:

&#x20;  `ssh -i "se-emeka-key-pair.pem" ubuntu@ec2-54-216-215-193.eu-west-1.compute.amazonaws.com`

* type yes when you receive the prompt `Are you sure you want to continue connecting`

* Congrats, you are now connected to your virtual machine


## EC2 app deployment
Try to update and upgrade programs on ubuntu on first use 
- To update(Download the updates)
  * `sudo apt update -y`
- To upgrade(swaps the old with  new updates)
  * `sudo apt upgrade -y`

Try to deploy Nginx web server:
- `sudo apt install nginx -y`

check the status of nginx using 

* `systemctl status nginx`
  * press q to exit or ctrl + c

Other handy codes for working with nginx

- `sudo systemctl start nginx` (start nginx service)
- `sudo systemctl stop  nginx` (stops nginx service)
- `sudo systemctl enable  nginx`(enables the service startup on boot)

## Automate nginx deployment using bash script

 * `#!/bin/bash`
  * `sudo apt install nginx -y`
  * `sudo systemctl start nginx`

How to get the script into  EC

* create the script on local machine 
* change permission 

  `chmod +x myscript.sh`

* transfer to remote from local 

`scp -i se-emeka-key-pair.pem /local/path/myscript.sh ubuntu@ec2-54-216-215-193.eu-west-1.compute.amazonaws.com:~`

* transfer to remote from local (conncetion with EC2 must exist)

  `scp myscript.sh ubuntu@ec2-54-216-215-193.eu-west-1.compute.amazonaws.com:~`


