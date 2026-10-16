# Joshua Cane
Cloud & Serverless Builder | AWS & Node.js/Python

my project that is in continual revamping and progress

What I’m posting here is the ultimate goal which I’m very close to having operational

I build event-driven, cost-optimized serverless applications on AWS with automated Infrastructure as Code (CloudFormation). Focused on cloud security best practices, scalable media delivery, and secure third-party integrations.
 

## Project Update & Baseline Reset (Oct 2026)

### Status & Retrospective
During the initial phase of the **fixyachips** project (Jan 2026 – Oct 2026), environment provisioning, adjustments, and troubleshooting steps were not tracked incrementally under standard version control or formal changelogs.

### Current State
As of **October 16, 2026**, Linux Mint 22 has been installed on the Dell Precision 7160, but final setup is still pending due to active Wi-Fi connectivity troubleshooting.

### Moving Forward
Historical chat logs are archived locally via Google Takeout. All future configuration steps, system fixes, and infrastructure updates will be strictly documented starting from our clean **v1.0.0 CHANGELOG baseline** and managed directly through Git commits.
## Core Technical Skills
* Cloud & IaC: AWS CloudFormation, S3, CloudFront, Lambda, API Gateway, DynamoDB, SQS, KMS
* Media & Integration: AWS Elemental MediaConvert, Stripe API/Webhooks
* Security: AWS WAF, IAM, Secrets Manager, Origin Access Control (OAC), HSTS/CSP Policies
* FinOps: S3 Intelligent-Tiering, DynamoDB On-Demand, S3 Lifecycle Policies

## Featured Project: Fixyachips VOD & Monetization Platform
A live, production-grade video-on-demand platform deployed via AWS CloudFormation.
* Architecture: CloudFront CDN with edge routing, MediaConvert automated transcoding pipeline, regional API Gateway with SQS Dead Letter Queues.
* Security: WAF rate-limiting and bot controls, KMS CMK encryption at rest, encrypted webhook handling via Secrets Manager.
* Data & Storage: DynamoDB on-demand billing with PITR, S3 tiering and lifecycle retention.
 
![Fixyachips VOD Pipeline Architecture](./Fixyachips-Network-Diagram.jpeg)
