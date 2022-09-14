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

if [ ! -d "$HOME/.nvm/alias" ]; then
    echo "Looks like we have not set anything up"
    echo
    echo "So I will set up nvm"
    echo
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

    echo "Now let's add some connectivity, prn:"
    echo
    cat ~/.ssh/id_rsa.pub

    echo
    echo "If necessary, copy the above RSA public key to https://github.com/settings/keys"
fi

echo "Use our default (latest) version of node"
nvm use default

EOL

cd /home/vagrant
git add .profile
git commit -m "Tell .profile to tell us how to get started"

if [ ! -d ~/nodeone ]; then
    mkdir nodeone
    cat >> /home/vagrant/nodeone/app.js <<EOL
const http = require('http');

const hostname = '0.0.0.0';
const port = 4000;

const server = http.createServer((req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/plain');
  res.end('Hello World');
});

server.listen(port, hostname, () => {
  console.log(\`Server running at http://\${hostname}:\${port}/\`);
});
EOL
fi

git add nodeone/
git commit -m "Create minimal node.js app"

echo "ABOUT TO SET UP vagrant setup-node-01.sh"
echo

cat >> /home/vagrant/setup-node-01.sh <<EOL
#!/bin/bash

echo "if repos don't work, need to copy ~/.ssh/id_rsa.pub to https://github.com/settings/keys"
git clone git@github.com:thunderrabbit/node-bugful-bounty.git
cd ~/node-bugful-bounty/
node app.js
EOL
chmod 755 setup-node-01.sh

cd /home/vagrant
git add setup-node-01.sh
git commit -m "Set up setup. Set up first repo"

if [ ! -f ~/.bash_history ]; then
  echo ".bash_history does not exist"
  echo "this must be first run"
  echo "So let's allow up-arrow to get this universe rolling"
  cat >> /home/vagrant/.bash_history <<EOL
. ./setup-node-01.sh
EOL
fi
