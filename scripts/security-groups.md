# Security Groups Configuration

## my-production-alb-sg (ALB)
| Port | Protocol | Source | Purpose |
|------|----------|--------|---------|
| 80 | HTTP | 0.0.0.0/0 | Public HTTP traffic |
| 443 | HTTPS | 0.0.0.0/0 | Public HTTPS traffic |

## my-production-ec2-sg (EC2)
| Port | Protocol | Source | Purpose |
|------|----------|--------|---------|
| 80 | HTTP | ALB SG only | Traffic from ALB only |
| 3306 | MySQL | ALB SG only | DB access |

## my-production-rds-sg (RDS)
| Port | Protocol | Source | Purpose |
|------|----------|--------|---------|
| 3306 | MySQL | EC2 SG only | DB access from EC2 only |

## Design principle
Least-privilege: EC2 not exposed to internet directly. Only ALB accepts public traffic.
