12 September 2022

I applied for a job which uses node.js

They want me to do a timed quiz with node.js so I'm setting up a VM that can
run node.js and lemme see output via web browser.

Resource https://code.tutsplus.com/courses/easy-nodejs-development-environment-with-vagrant/lessons/the-vagrantfile

### yeah, yeah, what do I do?

1. clone this repo
2. vagrant up
3. vagrant ssh
    `~/.profile` automagically installs nvm, sets up node
4. copy ssh key to github
5. vagrant@ubuntu-jammy:> . ./setup-node-01.sh

automagically:

* clone repo
* cd ~/node-bugful-bounty
* node app.js

6. View http://127.0.0.1:4000/homey in browswer
7. View http://127.0.0.1:4000/home in browswer

### next steps

Install MongoDB
eff around with it a bit

### next next steps

Install Postgres
eff around with it a bit

Part III

clone this
vagrant up
take timed test