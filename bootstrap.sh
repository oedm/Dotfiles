#!/usr/bin/env bash

set -e

# Main playbook
PLAYBOOK="dotfiles.yml"
DOTFILES_PRIVATE="$(dirname $(pwd))/dotfiles-private"

if ! command -v ansible &> /dev/null;then
  echo "ansible not found. Attempt to install."
  if dpkg -S /bin/ls >/dev/null 2>&1;then
    sudo apt update && sudo apt install -y ansible python3-pip
    pip3 install --user github3.py
  elif rpm -q -f /bin/ls >/dev/null 2>&1;then
    sudo yum install ansible
  else
    echo "Don't know this package system (neither RPM nor DEB)."
    exit 1
  fi
else
  echo "ansible already installed."
fi

read -p "Should I also install the private dotfiles as well? (y/n)" -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    ansible-playbook -i hosts "$PLAYBOOK" \
      --ask-become-pass --ask-vault-pass \
      --extra-vars "privateInstall=True"
    if [ -d "$DOTFILES_PRIVATE" ];then
      cd $DOTFILES_PRIVATE
      echo "Starting private part of deployment."
      ansible-playbook -i hosts "$PLAYBOOK" \
      --ask-become-pass --ask-vault-pass
    fi
else
    ansible-playbook -i hosts "$PLAYBOOK" \
      --ask-become-pass
fi

exit 0
