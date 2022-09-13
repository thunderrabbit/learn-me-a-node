# configure git for vagrant
git config --global user.name "Ansible on Vagrant"
git config --global user.email ansible.on.vagrant@robnugen.com
git config --global init.defaultBranch master

git config --global --add safe.directory /home/vagrant       # otherwise complains about owned by someone else

cd /home/vagrant/
git init

git add .gitconfig
git commit -m "New Server Who Diss?"

git add .gitconfig
git commit -m "Allow git to be used at home

git config --global --add safe.directory /home/vagrant"

## set up .gitignore
curl -s https://www.toptal.com/developers/gitignore/api/emacs%2Cansible > /home/vagrant/.gitignore

cd /home/vagrant
git add .gitignore
git commit -m "Add .gitignore for emacs and node

https://www.toptal.com/developers/gitignore/api/emacs%2Cnode"

echo ".bash_history" >> .gitignore
echo ".ssh/" >> .gitignore
echo ".nvm/" >> .gitignore
git add .gitignore
git commit -m "Add .gitignore for other stuff"

# configure git for user vagrant
cat >> /home/vagrant/.bash_aliases <<EOL
alias t='tmux new -A -s robone'
alias gitd='git diff -b'
alias gitds='git diff --staged'
alias gita='git add'
alias gitl='git log --oneline --graph --decorate --all'
alias gits='git status'
alias gitc='git restore . ; git clean -f'
EOL

git add .bash_aliases
git commit -m "Create .bash_aliases"

echo "ABOUT TO SET UP vagrant .profile"
echo

cat >> /home/vagrant/.profile <<EOL
export EDITOR=/usr/bin/emacs

if [ ! -d ~/WHATEVERWILLBENODEdirectory ]; then
    echo "Looks like we have not set anything up"
    echo "So let's start with connectivity:"
    echo
    cat ~/.ssh/id_rsa.pub

    echo
    echo "If necessary, copy the above RSA public key to https://github.com/settings/keys"

    # Run '. ./setup.sh' instead of just ./setup.sh to make the ENV variables stick.
    echo "and then up-arrow a bit to run '. ./setup.sh'"

    echo "After that, do something like this, depending on the project you will work on:"
    echo
    echo "cd ~/create-batman.co.jp-on-aws"
    echo ". ./setup.sh"
fi
EOL

cd /home/vagrant
git add .profile
git commit -m "Tell .profile to tell us how to get started"


echo "ABOUT TO SET UP vagrant setup.sh"
echo

cat >> /home/vagrant/setup.sh <<EOL
#!/bin/bash

echo "if repos don't work, need to copy ~/.ssh/id_rsa.pub to https://github.com/settings/keys"
echo "This is where we need to set up node for playing around"

echo "HEY THIS MIGHT BE INSTALLING AN"
echo "OLD VERSION OF nvm.  Check out latest at"
echo https://github.com/nvm-sh/nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
echo "Assuming vagrant needs the alias defined for nvm:"
source /home/vagrant/.bashrc
echo "Install latest version of node"
nvm install node
echo "Make latest version default"
nvm alias default node
echo "Use our default (latest) version of node"
nvm use default

cd ~
EOL
chmod 755 setup.sh

cd /home/vagrant
git add setup.sh
git commit -m "Set up setup. Set up nvm"

if [ ! -f ~/.bash_history ]; then
  echo ".bash_history does not exist"
  echo "this must be first run"
  echo "So let's allow up-arrow to get this universe rolling"
  cat >> /home/vagrant/.bash_history <<EOL
. ./setup.sh
EOL
fi
