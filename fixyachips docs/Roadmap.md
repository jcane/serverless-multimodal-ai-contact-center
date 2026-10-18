# 🛠️ VOD Infrastructure Project: 30-Day Roadmap

## Phase 1: Storage & Global Delivery (Days 1–7)
*Goal: Get a video file in the cloud and viewable via a secure URL.*
- [ ] **Day 1:** Create S3 Buckets (`source` and `processed`). Block Public Access.
- [ ] **Day 2:** Setup CloudFront Distribution + Origin Access Control (OAC).
- [ ] **Day 3:** Host a static `index.html` in S3 and view via CloudFront URL.
- [ ] **Day 4:** IAM Deep Dive: Create the "MediaRole" with S3 & MediaConvert policies.
- [ ] **Day 5:** Refresh S3 Bucket Policies to allow CloudFront OAC access.
- [ ] **Day 6:** Manual Test: Upload a video, get it to play through the CDN.
- [ ] **Day 7:** Week 1 Review: Document your bucket ARNs and CloudFront ID.

## Phase 2: Transcoding Engine (Days 8–15)
*Goal: Automate video processing using AWS Elemental MediaConvert.*
- [ ] **Day 8:** Create a MediaConvert HLS Job Template.
- [ ] **Day 9:** Create the "Transcode Trigger" Lambda function.
- [ ] **Day 10:** Add S3 "ObjectCreated" trigger to the Lambda.
- [ ] **Day 11:** Write Boto3 Python code to submit jobs to MediaConvert.
- [ ] **Day 12:** Configure Lambda Environment Variables (Template names, ARNs).
- [ ] **Day 13:** Test the pipeline: Upload MP4 -> Automatic HLS conversion.
- [ ] **Day 14:** Debugging: Check CloudWatch Logs for any "Access Denied" errors.
- [ ] **Day 15:** Cleanup: Ensure processed files are landing in the correct S3 folder.

## Phase 3: Identity & Paywall (Days 16–23)
*Goal: Secure content so only paid users can watch.*
- [ ] **Day 16:** Setup Cognito User Pool (Email-based login).
- [ ] **Day 17:** Create API Gateway (REST API) with a `/get-video` resource.
- [ ] **Day 18:** Connect Cognito Authorizer to the API Gateway.
- [ ] **Day 19:** Setup Stripe Developer Account & API Keys.
- [ ] **Day 20:** Lambda Logic: Create a "Stripe Checkout" function.
- [ ] **Day 21:** Create DynamoDB Table (`Users`) to track subscription status.
- [ ] **Day 22:** Setup Stripe Webhook (Lambda) to update DynamoDB on payment.
- [ ] **Day 23:** Verify Auth: Test that API calls fail without a Cognito token.

## Phase 4: Integration & Global Scale (Days 24–30)
*Goal: The "Grand Opening" - Connect the frontend to the backend.*
- [ ] **Day 24:** Frontend: Add AWS Amplify Auth to your `index.html`.
- [ ] **Day 25:** Logic: If `isSubscribed` is true, call API for a Signed URL.
- [ ] **Day 26:** Security: Generate CloudFront Signed URLs in Lambda.
- [ ] **Day 27:** UI: Build a simple "Video Gallery" using the signed links.
- [ ] **Day 28:** Marketing: Setup AI-driven ad copy for Mechanic/Tech niche.
- [ ] **Day 29:** Global Check: Test video playback speed from a different region (VPN).
- [ ] **Day 30:** **LAUNCH!** Upload your first instructional masterclass.
