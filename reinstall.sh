#!/bin/bash/

set -oeux pipefail
mdkir ~/bin/
for prog in  tmux wget emacs  fonts-inconsolata libssl-dev libxml2-dev libcurl4-openssl-dev ruby
do
  sudo apt-get install $prog -y
done
curl https://raw.githubusercontent.com/rcaloras/bash-preexec/master/bash-preexec.sh -o ~/.bash-preexec.sh

echo "source .nickstuff" >> ~/.bashrc
cp ./.nickstuff ~/
mkdir ~/.config/
ln -s ./.config/* ~/.config/

wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
conda config --add channels defaults
conda config --add channels conda-forge
conda config --add channels bioconda
rm Miniconda3-latest-Linux-x86_64.sh

#####################  get docker happening

sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common -y


curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

sudo apt-get update && sudo apt-get install docker-ce docker-ce-cli containerd.io -y

sudo gem install teamocil

mkdir ~/.teamocil/
cat <<EOF > ~/.teamocil/def.yaml
windows:
  - name: research
    root: ~/bioskryb_research/
    panes:
      - echo "ready to do some crazy research?"
  - name: workflows
    root: ~/bioskryb_scripts_and_workflows/
    panes:
      - git status
  - name: utils
    root: ~/skrybutils
    panes:
      - git status
  - name: jupyter
    root: ~/
    panes:
      - sudo docker run --rm -e GOOGLE_APPLICATION_CREDENTIALS=$GOOGLE_APPLICATION_CREDENTIALS -eCROMWELL_SERVER_URL=$CROMWELL_SERVER_URL -e GCP_PROJECT=$GCP_PROJECT -e JUPYTER_ENABLE_LAB=yes  -p 80:8888 -v /mnt/disks/big-disk/:/mnt/disks/big-disk/ -v "$PWD":/home/jovyan/work -e GRANT_SUDO=yes --user root gcr.io/bioskryb-nick/devmachine:0.0.3
EOF
