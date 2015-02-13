# VestaCP Admin Scripts
##### Developed by Bryan Karaffa

These scripts are meant to automate common workflows for administrators that
use VestaCP.

## Requirements
 - You must have Vesta CP installed and running on a server.  Instructions for how to do this are available at the Vesta CP website [http://vestacp.com/#install]

 - Scripts are written in `bash` and must be run on Linux, OS X, or equivalent.  You can run them on the remote server if you wanted, but they are designed to be run remotely from any machine.

 - You must have an account created in Vesta **with SSH Access** (the default `admin` account is okay)

 - SSH/rsync is used to upload files.  You must have SSH Key based authentication configured to prevent being prompted for a password multiple times.  I have provided `setup-ssh-key-authentication.sh` which will configure this automatically (only needs to be done once per account that you will be managing)

## How to Use

### Step 1: Use git to download/clone the repo

```bash
# Use git to clone the repo from github
$ git clone https://github.com/bryankaraffa/vestacp-admin-scripts.git

# Change directory into the scripts directory
$ cd vestacp-admin-scripts
 ```

#### Step 2: Setup SSH Key Authentication [Recommended]
If you haven't already done so, we configuring SSH Key based authentication with the remote server for secure authentication and to prevent being prompted for a password multiple times throughout the scripts.

You can run `setup-ssh-key-authentication.sh` which will copy your ssh key to the remote server's ~/.ssh/authorized_keys and grant SSH access without a password.

```bash
$ ./setup-ssh-key-authentication.sh
Your VestCP username, followed by [ENTER]:
admin
Your VestaCP hostname, followed by [ENTER]:
yourserver.com
[setup-ssh-key-authentication] SSH Key added to admin@yourserver.com:~/.ssh/authorized_keys successfully!

```


To verify SSH Key authentication was setup successfully, simply try to login to the server using SSH, and you should **not** be prompted for a password:

```bash
$ ssh admin@yourserver.com

Last login: Fri Feb 13 16:20:00 2015 from xxx.xxx.xxx.xxx
admin@yourserver:~$  # You've successfully logged into the server
```

##### When you have the scripts downloaded and SSH Key authentication setup, you are now ready to use the operational scripts!

# Operational Scripts

### create-wordpress-site.sh NEWDOMAIN [IPADDRESS]
This script will create a new Domain and DB in Vesta CP; download and extract the latest WordPress archive to the public_html directory.  The final WordPress configuration is done via a web browser.

```bash
$ ./create-wordpress-site.sh wordpress.yourserver.com
Your VestaCP hostname, followed by [ENTER]:
yourserver.com
Your VestaCP username, followed by [ENTER]:
admin
Your VestaCP user password, followed by [ENTER]:
[create-wordpress-site] Creating domain via API call
[create-wordpress-site] Rebuilding the web configs via API call
[create-wordpress-site] Downloading WordPress latest.tar.gz
[create-wordpress-site] Unpacking wordpress latest.tar.gz
[create-wordpress-site] Uploading wordpress files to ~/web/wordpress.yourserver.com/public_html
[create-wordpress-site] Removing ~/web/wordpress.yourserver.com/public_html/index.html
[create-wordpress-site] Creating Database via API call
[create-wordpress-site] ********************************************
[create-wordpress-site] MySQL DB Credentials
[create-wordpress-site] Database: admin_wp_wordpressyourservercom
[create-wordpress-site] Username: admin_wp_wordpre
[create-wordpress-site] Password: UuqD+Iji6ZHzN3wZqmV/ww==
[create-wordpress-site] ********************************************
[create-wordpress-site] Completed!
[create-wordpress-site] You can now visit the website to finish the installation.
```

# Task List (TODOs)
 - [ ] Modularize `create-wordpress-site.sh` so that it can be used to deploy other PHP scripts other than WordPress

 ** Scripts to implement **
    - [ ] Simple Machines Forum (SMF)
    - [ ] phpBB
    - [ ] bbPress
    - [ ] phpMyFAQ
    - [ ] DokuWiki
    - [ ] MediaWiki
    - [ ] Tiki Wiki
    - [ ] Geeklog
    - [ ] Joomla
    - [ ] Drupal
    - [ ] SugarCRM
    - [ ] Feng
    - [ ] Magento
    - [ ] Moodle
    - [ ] LimeSurvey
    - [ ] osTicket
    - [ ] Gallery
    - [ ] Coppermine
    - [ ] Zenphoto
    - [ ] Piwigo
    - [ ] Mantis
    - [ ] PHPProjekt
    - [ ] Gregarius
    - [ ] SimplePie
    - [ ] Roundcube
    - [ ] liveSite
    - [ ] BasicPages
    - [ ] concrete5
