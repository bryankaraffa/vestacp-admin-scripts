#!/bin/bash -e
#
# create-wordpress-site.sh
#
# Automatically creates a domain, DB, and installs the latest version of WordPress.

### Get Hostname
if [ -z "$vst_hostname" ]; then
  echo "Your VestaCP hostname, followed by [ENTER]:"
  read vst_hostname
fi
### Get Username
if [ -z "$vst_username" ]; then
  echo "Your VestCP username, followed by [ENTER]:"
  read vst_username
fi
### Get Password
if [ -z "$vst_password" ]; then
  echo "Your VestaCP user password, followed by [ENTER]:"
  read vst_password
fi
if [ -z "$vst_newdomain" ]; then
  echo "Desired domain name for WordPress, followed by [ENTER]:"
  read vst_newdomain
fi

echo '[create-wordpress-site] Executing API Call using curl'
## Execute API Call to create domain
curl -s -X POST https://$vst_hostname:8083/api/ \
-d user="$vst_username" \
-d password="$vst_password" \
-d returncode="yes" \
-d cmd="v-add-domain" \
-d arg1="$vst_username" \
-d arg2="$vst_newdomain"
