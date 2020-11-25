#!/bin/bash

# Amazon
# yum install -y httpd
# /etc/rc.d/init.d/httpd start

# Ubuntu
apt-get install -y nginx
service nginx start

mkdir -p /var/www/html
cd /var/www/html
wget https://s3.amazonaws.com/intro-to-devops-meetup/website.zip -O website.zip

# Ubuntu
apt-get install -y unzip
unzip website.zip

yum install -y curl
export AWS_REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | grep region | awk -F\" '{print $4}')
mkdir -p /root/.aws
echo -e "[default]\nregion=$AWS_REGION" | tee /root/.aws/config
export AWS_ACCESS_KEY_ID=FILL_IN
export AWS_SECRET_ACCESS_KEY=FILL_IN
export FQDN=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)" "Name=key,Values=Name" --output=text | cut -f 5)

hostname $FQDN
# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/set-hostname.html
# Annoyingly, ami-1853ac65 is an Amazon AMI but doesn't have hostnamectl installed
# Looking at the Description in EC2 > AMIs it says "2017.09.1.20180307 x86_64 HVM GP2".
# Checking on the box, this is an Ubuntu AMI hence why no hostnamectl

sed -i "s|Just another web server|<strong>$FQDN</strong>, another web server|g" /var/www/html/index.html; cat /var/www/html/index.html
# https://stackoverflow.com/questions/584894/environment-variable-substitution-in-sed
