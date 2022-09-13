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
