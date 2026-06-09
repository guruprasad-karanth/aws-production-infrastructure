# Troubleshooting Guide

## 1. SSL Certificate Validation Stuck
Problem: ACM certificate stuck in Pending validation
Fix: Add CNAME record in Route53 hosted zone matching ACM validation record
Time: DNS propagation takes 5-30 mins

## 2. CloudFront Not Serving Updated Content
Problem: Old content served despite EC2 update
Fix: Invalidate CloudFront cache
Command: Create invalidation for /* path in CloudFront console

## 3. ALB Health Check Failing
Problem: Instances showing unhealthy in target group
Fix: Verify EC2 security group allows port 80 from ALB SG
Fix: Verify httpd is running: systemctl status httpd

## 4. RDS Connection Refused
Problem: App cannot connect to RDS
Fix: Check RDS SG allows port 3306 from EC2 SG only
Fix: Verify RDS is in private subnet, not public

## 5. Auto Scaling Not Triggering
Problem: Traffic high but no new instances launching
Fix: Check CloudWatch CPU alarm threshold
Fix: Verify Launch Template has correct AMI and userdata

## 6. Route53 Domain Not Resolving
Problem: Custom domain not pointing to CloudFront
Fix: Ensure A record is alias pointing to CloudFront distribution
Fix: Check nameservers match Route53 hosted zone NS records
