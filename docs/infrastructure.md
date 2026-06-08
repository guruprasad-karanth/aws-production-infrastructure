# Infrastructure Details

## VPC & Networking

| Resource | Value |
|---|---|
| VPC CIDR | 10.0.0.0/16 |
| Public Subnets | 2 (ALB layer) across ap-south-1a and ap-south-1b |
| Private Subnets | 2 (EC2 layer) — no direct internet access |
| DB Subnets | 2 (RDS layer) — isolated, no internet access |
| Internet Gateway | Attached to VPC for public subnet routing |
| Route Tables | Public subnets route to IGW; private subnets have no IGW route |

### Security Group Rules

| Security Group | Inbound | Outbound |
|---|---|---|
| ALB SG | 80 (HTTP) and 443 (HTTPS) from 0.0.0.0/0 | All traffic |
| EC2 SG | Port 80 from ALB SG only | All traffic |
| RDS SG | Port 3306 from EC2 SG only | All traffic |

---

## Compute

| Resource | Value |
|---|---|
| Instance Type | t3.micro |
| AMI | Amazon Linux 2 |
| Launch Template | my-production-lt (Version 2) |
| ASG Name | my-production-asg |
| Min Instances | 1 |
| Desired Instances | 2 |
| Max Instances | 3 |
| AZs | ap-south-1a and ap-south-1b |
| User Data | Installs and starts web server on boot |

### Auto Scaling Policies
- Scale-out: triggered by `high-cpu-alarm` when CPU > 80% for 10 minutes
- Scale-in: triggered when CPU returns to normal

---

## Load Balancer

| Resource | Value |
|---|---|
| Type | Application Load Balancer (ALB) |
| Scheme | Internet-facing |
| Subnets | Public subnets across 2 AZs |
| HTTP Listener | Port 80 — 301 redirect to HTTPS |
| HTTPS Listener | Port 443 — forwards to target group |
| Health Check Path | / |
| Health Check Interval | 30 seconds |

---

## SSL/TLS

| Resource | Value |
|---|---|
| Certificate Type | Wildcard (*.guruprasadkaranth.com) |
| Validation Method | DNS (CNAME in Route53) |
| ap-south-1 Certificate | Attached to ALB |
| us-east-1 Certificate | Attached to CloudFront (AWS requirement) |
| Renewal | Automatic via ACM |

---

## CDN

| Resource | Value |
|---|---|
| Origin | ALB (custom origin) |
| Protocol | HTTPS only to origin |
| TLS Version | TLSv1.2 minimum |
| HTTP Version | HTTP/2 |
| Default TTL | 24 hours |
| Compression | Gzip enabled |
| Domain Alias | guruprasadkaranth.com |

---

## Database

| Resource | Value |
|---|---|
| Engine | MySQL 8.0 |
| Instance Class | db.t3.micro |
| Subnets | Private DB subnets (isolated) |
| Public Access | No |
| Deletion Protection | Enabled |
| Backups | Automated daily (1-day retention) |
| Encryption | At rest with AWS-managed key |
| Port | 3306 (from EC2 SG only) |

---

## IAM

| Policy | Purpose |
|---|---|
| CloudWatchAgentServerPolicy | Allows EC2 to send metrics to CloudWatch |
| AmazonSSMManagedInstanceCore | Allows SSH-free access via SSM Session Manager |

- Role attached as instance profile to Launch Template Version 2
- Every Auto Scaling instance gets the role automatically on launch

---

## Observability

### CloudWatch Alarms

| Alarm | Metric | Threshold | Action |
|---|---|---|---|
| high-cpu-alarm | ASG CPUUtilization | > 80% for 10 min | Scale-out + SNS alert |
| alb-unhealthy-hosts | UnHealthyHostCount | >= 1 | SNS alert |
| rds-low-storage | FreeStorageSpace | < 2GB | SNS alert |

### CloudWatch Dashboard
- `production-dashboard` showing CPU, RequestCount, UnHealthyHostCount, FreeStorageSpace

### SNS
- Topic: `production-alerts`
- Subscription: email (confirmed)
- All 3 alarms attached

### Route53 Health Check
- Name: `production-website-health`
- Endpoint: https://guruprasadkaranth.com:443/
- Protocol: HTTPS
- Request interval: 30 seconds
- Failure threshold: 3 consecutive failures
- CloudWatch alarm: `website-health-alarm` → SNS `production-alerts`

---

## Access & Logging

### SSM Session Manager
- Both EC2 instances registered and Online in SSM
- No SSH keys required — access via AWS Console or CLI
- Port 22 not open in Security Groups

### S3 ALB Access Logs
- Bucket: `production-alb-logs-135728714316`
- Region: ap-south-1
- Prefix: `alb-logs/`
- Public access: blocked
- ELB service account (718504428378) granted PutObject via bucket policy
