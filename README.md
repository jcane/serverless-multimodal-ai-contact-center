# Fixyachips Enterprise VOD & Monetization Platform (v4.4.2)

## Overview
The Fixyachips Enterprise VOD & Monetization Platform is a secure, highly scalable serverless solution deployed live on AWS via CloudFormation. It powers global video-on-demand (VOD) streaming through Amazon CloudFront and AWS Elemental MediaConvert, while managing secure customer signups and Stripe payment webhook integrations via API Gateway, Lambda, and DynamoDB.

## Architecture & Core Resources
* **Storage & Content Delivery:** 
  * `StreamingVideoBucket`: S3 bucket configured for raw video ingestion (`raw/`), transcoded HLS outputs (`videos/`), AES256 encryption, intelligent tiering, and strict OAC access.
  * `AccessLogsBucket`: Centralized storage for CloudFront and S3 access logs with a 90-day lifecycle retention policy.
  * `WebsiteDistribution`: Global CloudFront CDN utilizing HTTP/2 & HTTP/3, IPv6, AWS WAF integration (`WebBodyguard`), and Origin Shielding.
  * `WebsiteRouterFunction`: Edge function handling clean URL routing and path traversal security.
* **Security & Compliance:**
  * `WebBodyguard`: WAF Web ACL enforcing rate-limiting (2000 requests per 5 minutes), AWS Managed Common Rules, Bot Control, and SQL injection protection.
  * `SecretsKMSKey` & `DynamoDBKMSKey`: Dedicated Customer Managed Keys (CMKs) with automatic key rotation for platform secrets and PII data encryption.
  * `StripeApiSecret`: Encrypted AWS Secrets Manager container protecting live Stripe API keys and webhook signing secrets.
  * `SecurityHeadersPolicy`: Enforces strict security headers including HSTS, CSP, and `X-Frame-Options: DENY`.
* **Transcoding & Monetization:**
  * `MediaConvertQueue`: Automated transcoding pipeline triggered by raw video uploads.
  * `StudentTable`: On-demand DynamoDB table featuring Point-in-Time Recovery and Global Secondary Indexes for customer lookups.
  * `PlatformApi`: Regional API Gateway managing client waitlists (`/signup`) and secure Stripe event webhooks (`/webhook/stripe`).
  * `SignupDLQ` & `StripeWebhookDLQ`: SQS Dead Letter Queues for fault-tolerant error management.

## Live Operations & Maintenance
To push infrastructure updates or manage deployments for your live stack:
```bash
aws cloudformation deploy --stack-name fixyachips-prod \
  --template-file template.yaml \
  --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM

🚀 About the Architect

I am a Fractional Cloud Solutions Architect specializing in the convergence of serverless cloud ecosystems, cost optimization (FinOps), and next-generation multimodal AI customer workflows.

Need to deploy an autonomous, enterprise-grade AI support center or global streaming matrix for your company? Let's build it.

    📧 Contact: info@fixyachips.com

<meta name="google-site-verification" content="kb6aVw-eDBwu4jRTNqTTP7hhsxdBZtXDyAWHC1ZnjTk" />

    💼 Availability: Fractional Advisory, Infrastructure Audits, and Custom Cloud Automation Sprints.
