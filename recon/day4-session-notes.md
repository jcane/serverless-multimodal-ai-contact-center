# Day 4 Session Notes — November 21 2026
# Duration: Approximately 2.5 hours
# Result: PIPELINE FULLY WORKING — 7 languages, 7 MP4 files confirmed in S3

## The Journey

Started Day 4 with a deployed ASL v2 and an IAM-fixed environment from previous sessions.
Thought we were close. Took 2.5 hours and 8 separate errors to get to green.
Every single error was fixable. None of them were architecture problems.
All fixes were done 100% from the command line — no console editing.

## Error 1 — videoSourcePath vs videoKey
**What happened:** Pipeline failed immediately on StartTranscribeJob.
**Cause:** ASL was built with $.videoKey but the actual pipeline input sends videoSourcePath.
**Fix:** sed replace across the ASL file, then Python script to remove States.Format wrapper since videoSourcePath is already a full S3 URI.

## Error 2 — Lambda body error
**What happened:** ExtractTranscript Lambda crashed with "Failed to extract transcript: 'body'"
**Cause:** Lambda was written for API Gateway which wraps input in a body key. Step Functions calls Lambda directly — there is no body wrapper.
**Fix:** Rewrote Lambda to read transcriptBucket and transcriptKey directly from the event, then fetch the transcript JSON from S3 using boto3.

## Error 3 — Lambda handler name mismatch
**What happened:** Lambda deployed but handler pointed to wrong filename.
**Cause:** New file was named extract_transcript_fixed.py but handler config still said extract_transcript.lambda_handler
**Fix:** aws lambda update-function-configuration --handler extract_transcript_fixed.lambda_handler

## Error 4 — Lambda timeout too short
**What happened:** Lambda would have timed out fetching from S3.
**Cause:** Timeout was set to 3 seconds. Not enough to make an S3 API call and parse JSON.
**Fix:** aws lambda update-function-configuration --timeout 30

## Error 5 — LambdaVODRole missing S3 read permission
**What happened:** Lambda crashed with AccessDenied on S3 GetObject for the transcript file.
**Cause:** LambdaVODRole had no S3 read permissions at all.
**Fix:** aws iam attach-role-policy --policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess

## Error 6 — AAC bitrate invalid for MediaConvert
**What happened:** MediaConvert rejected the job with bitrate validation error.
**Cause:** 96000 bitrate is not valid for CODING_MODE_2_0 at 22050hz sample rate.
**Fix:** Changed Bitrate from 96000 to 32000 in both RunMediaConvertEnglish and RunMediaConvertPolly.

## Error 7 — Polly OutputUri is HTTPS not S3
**What happened:** MediaConvert got 403 Access Forbidden trying to read the Polly MP3.
**Cause:** Polly returns OutputUri as https://s3.us-east-1.amazonaws.com/bucket/... but MediaConvert needs s3://bucket/...
**Fix:** Added ConvertPollyUri Pass state after IsPollyComplete that converts the HTTPS URI to S3 URI using States.Format and States.StringSplit.

## Error 8 — ArrayGetItem index wrong
**What happened:** ConvertPollyUri failed with Invalid arguments in States.ArrayGetItem.
**Cause:** Guessed the wrong array index position for the filename after splitting the URL by /. Tried 8, then 7, then 6 — all wrong because Step Functions StringSplit skips empty strings.
**Fix:** Stopped guessing. Used States.ArrayLength minus 1 to always get the last element regardless of array size. Bulletproof solution suggested by AWS console diagnostic tool.

## Final Result
Execution 5e726f50-87ab-430a-81bc-364288b1ec31
Duration: 2 minutes 36 seconds
Status: SUCCEEDED
Output:
  en — 40001211 bytes
  es — 40004114 bytes
  pt — 40004308 bytes
  fr — 40000879 bytes
  de — 40001088 bytes
  it — 40000685 bytes
  pl — 40001277 bytes

## Lessons Learned
1. Always check what keys the pipeline input actually sends before writing ASL
2. Lambda written for API Gateway will not work when called directly from Step Functions
3. IAM roles need explicit S3 permissions — nothing is assumed
4. MediaConvert AAC bitrate has strict valid combinations — always check the docs
5. Polly always returns HTTPS URIs — always convert to S3 URI before passing to MediaConvert
6. Never guess array indices — use ArrayLength minus 1 for last element
7. The command line is faster than the console for every single one of these fixes
