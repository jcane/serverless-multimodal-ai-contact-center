# Fixyachips Build Session Notes
# Date: November 2026

## PLATFORM OVERVIEW
- Fixyachips Method = windshield repair TRAINING platform
- Division of Canes Windshield Repair (Joshua Cane)
- Larry = original master, active advisor, royalty partner
- Joshua trained by Larry in 1982
- Less than 6 people learned this method originally
- Available in 7 languages: EN DE ES FR IT PL PT
- Swedish DROPPED

## AWS ACCOUNT
Account ID: 980049663300
Region: us-east-1

## CONNECT INSTANCE
Name: fixyachips-global
ID: 6740280a-eba6-475a-a0ee-8be20550d799
URL: https://fixyachips-global.my.connect.aws

## CONTACT FLOWS (BUILT)
- fyc-general-inquiry-flow
- fyc-training-inquiry-flow
- fyc-brand-inquiry-flow
- fyc-test-lambda
- fyc-minimal-test
- fyc-test-attrs

## QUEUES (BUILT)
- fyc-general-inquiry
- fyc-training-inquiry
- fyc-brand-inquiry
- BasicQueue

## LAMBDA (BUILT)
- FixYaChips_Chat_Data_Router
- Runtime: nodejs24.x arm64
- Points to: DynamoDB FixYaChips_Leads
- Cognito: us-east-1_Phv5O6G1D

## ALL LAMBDA FUNCTIONS
- fixyachips-extract-transcript
- FixyachipsSignupWorker-Fixyachips-App-V1
- FixYaChips_Chat_Data_Router
- FixyachipsStripeWebhook-Fixyachips-App-V1
- Fixyachips-Video-Factory-Trigger
- VOD-Pipeline-Trigger
- FixyachipsCheckoutWorker-Fixyachips-App-V1
- Fixyachips-PostConfirmation-Trigger
- FixyachipsMediaConvertTrigger-Fixyachips-App-V1

## DYNAMODB TABLES
- FixYaChips_Leads (Email PK, CaptureTimestamp SK)
- FixYaChips-VOD-Heartbeats
- FixyachipsStudents-Fixyachips-App-V1
- FixyachipsStudents-prod-Fixyachips-App-V1
- fixyachips-terraform-locks

## COGNITO
Pool ID: us-east-1_Phv5O6G1D
Name: Fixyachips_Global_Users-Fixyachips-App-V1
Custom attrs: veteran_status, industry_segment

## CLOUDFRONT DISTRIBUTIONS
E1BVP04I7B9G57 → fixyachips-platform-980049663300 us-east-1 (PROD US)
E2Q5GUF99YQJQM → fixyachips-platform-980049663300 eu-west-1 (PROD EU)
EO34RY1DNDUK4  → fixyachips.s3-website (OLD)
EBF5RAJJKD80   → caneswindshieldrepair.com (parent brand)
E37J1MKSSBSXTQ → kansho-platform

## S3 FRONTEND BUCKET
fixyachips-platform-980049663300

## API GATEWAY
REST: FixyachipsAPI-Fixyachips-App-V1 (id: 4mbwbdlril)
HTTP: Fixyachips-Waitlist-API (id: m4w30c04d3)

## PAGES NEEDING CHAT WIDGETS (21 TOTAL)
Root EN:  index.html, philosophy.html, training.html
DE:       de/index.html, de/philosophy.html, de/training.html
ES:       es/index.html, es/philosophy.html, es/training.html
FR:       fr/index.html, fr/philosophy.html, fr/training.html
IT:       it/index.html, it/philosophy.html, it/training.html
PL:       pl/index.html, pl/philosophy.html, pl/training.html
PT:       pt/index.html, pt/philosophy.html, pt/training.html

## WHAT IS BUILT
✅ Connect instance
✅ Contact flows (3 fyc flows)
✅ Queues (3 fyc queues)
✅ Routing profile
✅ Lambda attached to Connect
✅ DynamoDB Leads table
✅ Cognito user pool
✅ CloudFront distributions
✅ API Gateway (REST + HTTP)
✅ Plain HTML pages (easy widget injection)
✅ 200 point KB content written and ready

## WHAT IS NOT BUILT YET
❌ S3 KB source bucket
❌ Bedrock Knowledge Base
❌ OpenSearch Serverless collection
❌ Bedrock Agent
❌ Chat widgets on 21 pages
❌ Connect snippet ID (need console)

## KNOWLEDGE BASE CONTENT
Part 1: 100 Reasons to REPAIR a windshield
        → For repair customers
        → Also teaches students their sales script

Part 2: 100 Reasons to LEARN Fixyachips Method
        → For prospective and enrolled students
        → Reinforces business opportunity

## CHAT WIDGET ROUTING LOGIC
Home page:       Both audiences, detect intent
Philosophy page: Repair customers, Part 1 KB
Training page:   Students, Part 2 KB

Queue routing:
Repair question  → fyc-general-inquiry
Training question → fyc-training-inquiry
Brand/story       → fyc-brand-inquiry

## AGENT LANGUAGE BEHAVIOR
Detects user language automatically
Responds in same language
Tone tailored per market:
DE → precision, quality, engineering
ES → warm, entrepreneurial, family
FR → artisan, craft, sustainable
IT → artisan mastery, craft pride
PL → opportunity, independence
PT → entrepreneurship, freedom

## BUILD ORDER WHEN YOU RETURN
PHASE 1 - Bedrock KB (1.5 hours)
1. Create S3 KB bucket
2. Upload 200 point text file
3. Create IAM role
4. Create OpenSearch collection
5. WAIT 15 mins for collection
6. Create Knowledge Base
7. Run ingestion job
8. WAIT 15 mins for ingestion

PHASE 2 - Agent (45 mins)
9.  Create Bedrock Agent
10. Load system prompt
11. Associate KB with agent
12. Create prod alias
13. WAIT 10 mins for preparation

PHASE 3 - Widgets (1 hour)
14. Get snippet ID from Connect console
15. Download 21 HTML pages
16. Inject widget into all 21 pages
17. Re-upload to S3
18. Invalidate CloudFront cache

PHASE 4 - Test (30 mins)
19. Test EN pages
20. Test each language
21. Verify queue routing
22. Verify lead capture
23. Verify VOD access for students

TOTAL ESTIMATED TIME: 4-6 hours

## IMPORTANT BRAND NOTES
- NEVER mention Steve Fine
- NEVER mention Fine Windshield Repair
- NEVER mention Glass Doctor
- Larry is the ORIGINAL master
- Larry taught Mike Fine (not the other way)
- Joshua trained in 1982 BEFORE Steve Fine
- Less than 6 people learned this originally
- Larry receives royalties from platform
- The chat widget IS the product demo

## ALL BUILD COMMANDS LOCATION
See previous chat session for complete
step by step CLI commands Steps 1-17
