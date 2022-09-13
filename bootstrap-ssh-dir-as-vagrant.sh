
git config --global --add safe.directory /home/vagrant/.ssh  # otherwise complains about owned by someone else

git add .gitconfig
git commit -m "Allow git to be used in .ssh

git config --global --add safe.directory /home/vagrant/.ssh"

# create an RSA key so we will be able to talk to bitbucket
ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''

cd /home/vagrant/.ssh/
git init
git add *
git commit -m "First version of vagrant's ssh key

so vagrant can clone git@bitbucket.org:sbstrm-deploy/create-fileswarm.net-on-aws.git"
