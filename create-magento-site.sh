#!/bin/bash -e
#
# create-magento-site.sh
#
# Automatically creates a domain, DB, and installs the latest version of magento.

vst_newdomain="$1"
vst_newdomain_ip="$2"

### Get Hostname
if [ -z "$vst_hostname" ]; then
  echo "Your VestaCP hostname, followed by [ENTER]:"
  read vst_hostname
fi
### Get Username
if [ -z "$vst_username" ]; then
  echo "Your VestaCP username, followed by [ENTER]:"
  read vst_username
fi
### Get Password
if [ -z "$vst_password" ]; then
  echo "Your VestaCP user password, followed by [ENTER]:"
  read -s vst_password
fi
if [ -z "$vst_newdomain" ]; then
  echo "Desired domain name for Magento site, followed by [ENTER]:"
  read vst_newdomain
fi

echo '[create-magento-site] Creating domain via API call'
## Execute API Call to create domain
curl -s -X POST https://$vst_hostname:8083/api/ \
-d user="$vst_username" \
-d password="$vst_password" \
-d returncode="yes" \
-d cmd="v-add-domain" \
-d arg1="$vst_username" \
-d arg2="$vst_newdomain" \
-d arg3="$vst_newdomain_ip"

echo '[create-magento-site] Rebuilding the web configs via API call'
## Execute API Call to rebuild web configs
curl -s -X POST https://$vst_hostname:8083/api/ \
-d user="$vst_username" \
-d password="$vst_password" \
-d returncode="yes" \
-d cmd="v-rebuild-web-domains" \
-d arg1="$vst_username"

vst_newdomain_publichtml="~/web/$vst_newdomain/public_html"

echo '[create-magento-site] Downloading magento latest.tar.gz'
curl -s -O http://www.magentocommerce.com/downloads/assets/1.9.1.0/magento-1.9.1.0.tar.gz

echo '[create-magento-site] Unpacking magento latest.tar.gz'
tar -zxf magento-1.9.1.0.tar.gz

echo "[create-magento-site] Uploading magento files to ~/web/$vst_newdomain/public_html"
rsync -e ssh -azh magento/* $vst_username@$vst_hostname:$vst_newdomain_publichtml

# Cleanup
rm -rf magento-1.9.1.0.tar.gz magento

echo "[create-magento-site] Removing $vst_newdomain_publichtml/index.html"
ssh $vst_username@$vst_hostname "rm $vst_newdomain_publichtml/index.html"

echo "[create-magento-site] Creating Database via API call"
## Generate DB Name
mysql_db_name="wp_${vst_newdomain//./}"
## Generate MySQL Username
mysql_username=$vst_username"_"$mysql_db_name
#### Shorten the MySQL username to make sure it's shorter than 16 chars (including the username)
mysql_username=${mysql_username:${#vst_username}+1:15-${#vst_username}}
## Generate a MySQL Password
mysql_password=$(openssl rand -base64 12)

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


echo "[create-magento-site] ********************************************"
echo "[create-magento-site] MySQL DB Credentials"
echo "[create-magento-site] Database: $vst_username"_"$mysql_db_name"
echo "[create-magento-site] Username: $vst_username"_"$mysql_username"
echo "[create-magento-site] Password: $mysql_password"
echo "[create-magento-site] ********************************************"

echo "[create-magento-site] Completed!"
echo "[create-magento-site] You can now visit the website to finish the installation."
exit 0
