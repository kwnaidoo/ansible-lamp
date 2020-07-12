# Ansible PHP-FPM stack

An ansible playbook that provisions Ubuntu servers to run a PHP-FPM app. This playbook is just a starting point and should be adapted accordingly to the project's needs.

# What is setup?

 - Some basic security and functionality most web servers would need such as:
	 - Disable root user login and password logins.
	 - Enable UFW and block all traffic besides SSH.
	 - Installs useful utilities if they are not installed by default. such as VIM, nano , htop, git 
	 - Setups up SSH access for the ansible user.
- A webserver with :
	- PHP-FPM
	- Nginx
	- Lets Encrypt - certbot and nginx plugin
- MySQL server

## Applying playbook

Note: Ubuntu user is created by default on digital ocean droplets, this maybe different for you:

    ansible-playbook playbook.yml -i hosts  --user ubuntu

 
