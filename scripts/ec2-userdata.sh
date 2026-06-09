#!/bin/bash
# EC2 User Data Script — Auto-runs on instance launch
# Used in Auto Scaling Launch Template

yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "<h1>Hello from $(hostname)</h1>" > /var/www/html/index.html
