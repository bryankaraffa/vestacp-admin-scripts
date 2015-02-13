# VestaCP Admin Scripts
##### Developed by Bryan Karaffa

These scripts are meant to automate common workflows for administrators that
use VestaCP.

## Requirements
 - Scripts are written in `bash` and must be run on Linux, OS X, or equivalent

 - You must have an account created in Vesta **with SSH Access** (`admin` account okay)

 - SSH is used to upload files.  You must have SSH Key based authentication configured to prevent typing in your password multiple times.  You can use `setup-ssh-key-authentication.sh` to configure this (only needs to be done once per account that you will be managing)

## Instructions
Make sure you have met all the requirements specified above, including SSH Key based authentication.  

## Task List (TODOs)
 - [ ] Modularize `create-wordpress-site.sh` so that it can be used to deploy other PHP scripts other than WordPress
