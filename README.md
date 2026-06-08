# Production-Grade AWS Infrastructure

A fully deployed, highly available cloud infrastructure on AWS for a personal web application — built hands-on across production environments.

**Live URL:** https://guruprasadkaranth.com  
**Region:** us-east-1 | **AZs:** 2 | **CloudFront ID:** EP0ENECNOA858

---

## Architecture

![AWS Architecture](architecture.png)

---

## Infrastructure components

| Layer | Service | Details |
|---|---|---|
| DNS | Route 53 | Custom domain, alias A records |
| CDN | CloudFront | Global edge, TLSv1.2, HTTP→HTTPS |
| SSL | ACM | Auto-renewed certificate |
| Load Balancer | ALB | Health checks, HTTPS listener |
| Compute | EC2 + Auto Scaling | t3.micro across 2 AZs |
| Database | RDS MySQL 8.0 | Multi-AZ, automated backups, deletion protection |
| Networking | VPC | Public/private/DB subnets across 2 AZs |
| Security | Security Groups | Least-privilege inbound/outbound rules |
| Identity | IAM | EC2 instance profile, CloudWatch + SSM access |
| Observability | CloudWatch | CPU, unhealthy host, and RDS storage alarms |

---

## What was built

- Deployed a VPC with public, private, and database subnet tiers across two availability zones
- Configured an Application Load Balancer with HTTPS enforcement and health checks
- Set up EC2 Auto Scaling across AZs with IAM instance profiles for least-privilege access
- Provisioned RDS MySQL 8.0 with automated backups and deletion protection in private DB subnets
- Issued and attached an ACM SSL certificate; configured HTTP → HTTPS redirect at the ALB
- Created a CloudFront distribution with custom domain alias pointing to the ALB origin
- Updated Route 53 hosted zone with alias A records for both the ALB and CloudFront
- Created CloudWatch alarms for CPU utilization, unhealthy host count, and RDS storage
- Troubleshot Linux server, DNS propagation, SSL validation, and deployment issues across environments

---

## Skills demonstrated

`AWS` `EC2` `ALB` `Auto Scaling` `CloudFront` `Route 53` `ACM` `RDS` `VPC` `IAM` `CloudWatch` `Security Groups` `Linux` `DNS` `HTTPS`