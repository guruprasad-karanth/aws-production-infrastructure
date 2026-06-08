# Troubleshooting & Problems Solved

Real issues encountered and resolved during the build — not from tutorials.

---

## 1. DNS Propagation Confusion

### Problem
After requesting an ACM certificate, the CNAME validation records were added to Network Solutions (the original domain registrar). The certificate stayed in "Pending validation" for hours despite the records being added correctly.

### Root Cause
Route53 nameservers had already been activated for the domain. Any DNS records added to Network Solutions were being ignored — Route53 was the authoritative nameserver, not Network Solutions.

### Fix
Added the ACM validation CNAME records directly to the Route53 hosted zone instead of Network Solutions. Certificate validated within minutes.

### Lesson
Always verify which nameserver is authoritative before adding DNS records. Route53 hosted zone nameservers must match the registrar's nameserver settings.

---

## 2. CloudFront Certificate Region Requirement

### Problem
After creating an ACM certificate in ap-south-1 (Mumbai) and attaching it to CloudFront, the certificate was not available in the CloudFront console dropdown.

### Root Cause
AWS requires ACM certificates to be in **us-east-1 (N. Virginia)** for use with CloudFront — regardless of where the infrastructure is deployed. This is a hard AWS requirement, not a configuration option.

### Fix
Requested a second ACM wildcard certificate (*.guruprasadkaranth.com) in us-east-1 specifically for CloudFront. The ap-south-1 certificate remained attached to the ALB.

### Lesson
Always provision two certificates when using CloudFront — one in your infrastructure region for ALB, one in us-east-1 for CloudFront.

---

## 3. Free Tier RDS Multi-AZ Restriction

### Problem
The original design called for Multi-AZ RDS deployment for high availability. During provisioning, Multi-AZ was unavailable and the option was greyed out.

### Root Cause
AWS Free Tier does not support Multi-AZ RDS deployment. The db.t3.micro instance class on free tier is limited to single-AZ only. Similarly, 7-day backup retention is not available — only 1-day retention is supported.

### Fix
Deployed single-AZ RDS with deletion protection enabled and automated daily backups (1-day retention). Architecture documented to reflect free tier limitation — Multi-AZ is the production design intent.

### Lesson
Always verify free tier restrictions before designing the architecture. Core availability design remains correct — only the RDS tier is limited by free tier constraints.

---

## 4. Launch Template IAM Role Propagation

### Problem
After creating the IAM instance role for CloudWatch and SSM access, existing EC2 instances did not have the role attached. SSM Session Manager showed no instances registered.

### Root Cause
The original Launch Template (Version 1) was created without an IAM instance profile. Existing EC2 instances launched from Version 1 inherited no IAM role. Modifying the role on running instances requires a relaunch.

### Fix
Created Launch Template Version 2 with the IAM instance profile attached. Updated the Auto Scaling Group to use Version 2. New instances launched from ASG automatically received the IAM role. Verified both instances appeared Online in SSM Session Manager.

### Lesson
Always attach IAM instance profiles at the Launch Template level — never rely on manual role attachment to individual instances. ASG instances must be relaunched to pick up new Launch Template versions.

---

## 5. SNS Pending Confirmation Cleanup

### Problem
After testing SNS notifications, a stale subscription appeared under SNS → Subscriptions showing "Pending confirmation" for a deleted topic (cpu-high-alert). The AWS console Delete button was greyed out for pending subscriptions.

### Root Cause
AWS does not assign ARNs to unconfirmed subscriptions, making them undeletable via the console UI. The parent topic (cpu-high-alert) was a leftover from an earlier test and was no longer needed.

### Fix
Deleted the parent topic (cpu-high-alert) via AWS CLI. The orphaned pending subscription was automatically cleaned up when its parent topic was removed.

```bash
aws sns delete-topic \
  --topic-arn arn:aws:sns:ap-south-1:135728714316:cpu-high-alert \
  --region ap-south-1
```

### Lesson
Clean up test SNS topics immediately after testing. Pending subscriptions cannot be deleted directly — always delete the parent topic to remove orphaned subscriptions.

---

## 6. CloudWatch Alarm State After Manual Testing

### Problem
After manually setting `high-cpu-alarm` to ALARM state for SNS testing, the alarm remained in ALARM state even though actual CPU was below 1%. This caused confusion about whether the infrastructure had a real issue.

### Root Cause
Manually setting alarm state via CLI overrides the metric-based evaluation. The alarm stays in the manually set state until the metric crosses the threshold again or is manually reset.

### Fix
Reset the alarm state back to OK via CLI after testing:

```bash
aws cloudwatch set-alarm-state \
  --alarm-name "high-cpu-alarm" \
  --state-value OK \
  --state-reason "Manual reset after SNS testing" \
  --region ap-south-1
```

### Lesson
Always reset manually triggered alarm states after testing. Document test procedures to avoid confusion between real alerts and test-triggered states.
