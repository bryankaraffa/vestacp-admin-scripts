#!/bin/bash -e
#
# create-wordpress-site.sh
#
# Automatically creates a domain, DB, and installs the latest version of WordPress.

vst_newdomain="$1"
vst_newdomain_ip="$2"

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
  read -s vst_password
fi
if [ -z "$vst_newdomain" ]; then
  echo "Desired domain name for WordPress, followed by [ENTER]:"
  read vst_newdomain
fi

echo '[create-wordpress-site] Creating domain via API call'
## Execute API Call to create domain
curl -s -X POST https://$vst_hostname:8083/api/ \
-d user="$vst_username" \
-d password="$vst_password" \
-d returncode="yes" \
-d cmd="v-add-domain" \
-d arg1="$vst_username" \
-d arg2="$vst_newdomain" \
-d arg3="$vst_newdomain_ip"

echo '[create-wordpress-site] Rebuilding the web configs via API call'
## Execute API Call to rebuild web configs
curl -s -X POST https://$vst_hostname:8083/api/ \
-d user="$vst_username" \
-d password="$vst_password" \
-d returncode="yes" \
-d cmd="v-rebuild-web-domains" \
-d arg1="$vst_username"

vst_newdomain_publichtml="~/web/$vst_newdomain/public_html"

echo '[create-wordpress-site] Downloading WordPress latest.tar.gz'
curl -s -O https://wordpress.org/latest.tar.gz

echo '[create-wordpress-site] Unpacking wordpress latest.tar.gz'
tar -zxf latest.tar.gz

echo "[create-wordpress-site] Uploading wordpress files to ~/web/$vst_newdomain/public_html"
rsync -e ssh -azh wordpress/* $vst_username@$vst_hostname:$vst_newdomain_publichtml

# Cleanup
rm -rf latest.tar.gz wordpress

echo "[create-wordpress-site] Removing $vst_newdomain_publichtml/index.html"
ssh $vst_username@$vst_hostname "rm $vst_newdomain_publichtml/index.html"

echo "[create-wordpress-site] Creating Database via API call"
## Generate DB Name
mysql_db_name="wp_${vst_newdomain//./}"
## Generate MySQL Username
mysql_username=$vst_username"_"$mysql_db_name
#### Shorten the MySQL username to make sure it's shorter than 16 chars (including the username)
mysql_username=${mysql_username:${#vst_username}+1:15-${#vst_username}}
## Generate a MySQL Password
mysql_password=$(openssl rand -base64 16)

curl -s -X POST https://$vst_hostname:8083/api/ \
-d user="$vst_username" \
-d password="$vst_password" \
-d returncode="yes" \
-d cmd="v-add-database" \
-d arg1="$vst_username" \
-d arg2="$mysql_db_name" \
-d arg3="$mysql_username" \
-d arg4="$mysql_password" \
-d arg5="mysql"


echo "[create-wordpress-site] ********************************************"
echo "[create-wordpress-site] MySQL DB Credentials"
echo "[create-wordpress-site] Database: $vst_username"_"$mysql_db_name"
echo "[create-wordpress-site] Username: $vst_username"_"$mysql_username"
echo "[create-wordpress-site] Password: $mysql_password"
echo "[create-wordpress-site] ********************************************"

echo "[create-wordpress-site] Completed!"
echo "[create-wordpress-site] You can now visit the website to finish the installation."
exit 0
