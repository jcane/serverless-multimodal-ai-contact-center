Hi, I'm Joshua Cane  
AWS Solutions Architect & Deployment Lead

I lead client discovery through enterprise architecture audits and rapid serverless execution to help companies slash operational budgets. We specialize in migrating enterprise environments away from legacy, outdated systems and Commercial Off-The-Shelf (COTS) software to zero-idle-cost AWS serverless ecosystems.

Core Focus & Expertise

Container-to-Serverless Migration: Deconstructing heavy, expensive legacy architecture into automated, event-driven serverless architectures.
FinOps & Cost Optimization:** Implementing S3 Intelligent-Tiering, automated log retention policies, and DynamoDB On-Demand modeling to eliminate idle infrastructure waste.
Enterprise Edge Security:** Hardening global applications with AWS WAF, custom rate-limiting, Bot Control, and strict transport encryption (HSTS/CSP).
Rapid Execution & Research:** Translating complex enterprise requirements into fully automated, production-ready AWS CloudFormation deployments.

 Fixyachips Enterprise VOD & Monetization Platform (v4.4.2)

Overview
The Fixyachips Enterprise VOD & Monetization Platform is a secure, highly scalable serverless solution deployed live on AWS via CloudFormation. It powers global video-on-demand (VOD) streaming through Amazon CloudFront and AWS Elemental MediaConvert, while managing secure customer signups and Stripe payment webhook integrations via API Gateway, Lambda, and DynamoDB.

Architecture & Core Resources
Storage & Content Delivery:  
   `StreamingVideoBucket`: S3 bucket configured for raw video ingestion (`raw/`), transcoded HLS outputs (`videos/`), AES256 encryption, intelligent tiering, and strict OAC access.
   `AccessLogsBucket`: Centralized storage for CloudFront and S3 access logs with a 90-day lifecycle retention policy.
   `WebsiteDistribution`: Global CloudFront CDN utilizing HTTP/2 & HTTP/3, IPv6, AWS WAF integration (`WebBodyguard`),  
    and Origin Shielding.
   `WebsiteRouterFunction`: Edge function handling clean URL routing and path traversal security.
Security & Compliance:
   `WebBodyguard`: WAF Web ACL enforcing rate-limiting (2000 requests per 5 minutes), AWS Managed Common Rules, Bot Control, and SQL injection protection.
   `SecretsKMSKey` & `DynamoDBKMSKey`: Dedicated Customer Managed Keys (CMKs) with automatic key rotation for platform secrets and PII data encryption.
   `StripeApiSecret`: Encrypted AWS Secrets Manager container protecting live Stripe API keys and webhook signing secrets.
   `SecurityHeadersPolicy`: Enforces strict security headers including HSTS, CSP, and `X-Frame-Options: DENY`.
Transcoding & Monetization:**
   `MediaConvertQueue`: Automated transcoding pipeline triggered by raw video uploads.
   `StudentTable`: On-demand DynamoDB table featuring Point-in-Time Recovery and Global Secondary Indexes for customer lookups.
   `PlatformApi`: Regional API Gateway managing client waitlists (`/signup`) and secure Stripe event webhooks (`/webhook/stripe`).
   `SignupDLQ` & `StripeWebhookDLQ`: SQS Dead Letter Queues for fault-tolerant error management.


### 📧 Contact & Availability
* **Email:** info@fixyachips.com
* **Engagement:** Fractional Advisory, Infrastructure Audits, and Custom Cloud Automation Sprints.
