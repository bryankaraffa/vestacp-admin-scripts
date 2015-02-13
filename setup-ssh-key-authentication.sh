#!/bin/bash -e
# setup-ssh-key-authentication.sh


### Get Username
if [ -z "$vst_username" ]; then
  echo "Your VestCP username, followed by [ENTER]:"
  read vst_username
fi
### Get Hostname
if [ -z "$vst_hostname" ]; then
  echo "Your VestaCP hostname, followed by [ENTER]:"
  read vst_hostname
fi
cat ~/.ssh/id_rsa.pub | ssh $vst_username@$vst_hostname "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
if [ $? -eq 0 ]; then
  echo "[setup-ssh-key-authentication] SSH Key added to $vst_username@$vst_hostname:~/.ssh/authorized_keys successfully!"
fi
exit 0
