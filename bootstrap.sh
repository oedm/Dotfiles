#!/usr/bin/env bash

set -e

# Dotfiles' project root directory
export ROOTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Host file location
HOSTS="$ROOTDIR/hosts"
# Main playbook
PLAYBOOK="$ROOTDIR/dotfiles.yml"

if ! command -v ansible &> /dev/null;then
  echo "ansible not found. Attempt to install."
  if dpkg -S /bin/ls >/dev/null 2>&1;then
    sudo apt update && sudo apt install -y ansible
  elif rpm -q -f /bin/ls >/dev/null 2>&1;then
    sudo yum install ansible
  else
    echo "Don't know this package system (neither RPM nor DEB)."
    exit 1
  fi
else
  echo "ansible already installed."
fi

ansible-playbook -i "$HOSTS" "$PLAYBOOK" --ask-become-pass

exit 0
