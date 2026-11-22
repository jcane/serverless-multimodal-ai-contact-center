# Session Log — November 21 2026
# Final Step Functions Work — Pipeline Now Works
# Duration: ~2.5 hours
# Result: PIPELINE FULLY WORKING — 7 languages, 7 MP4 files confirmed in S3

## Session Start State
- ASL v2 was written and saved from previous session
- IAM fixes were complete from previous session
- Pipeline had never successfully completed a full execution
- Starting at Day 4 — deploy and test

## Commands Run and Outputs

### Step 1 — Find ASL File

find /home/jcane/Documents/VOD-Project -name "*.json" | grep -i "v2|asl|state"

Found:
- /home/jcane/Documents/VOD-Project/asl/vod-pipeline-v2.json
- /home/jcane/Documents/VOD-Project/stepfunctions/vod-localization-pipeline-v2.json
- /home/jcane/Documents/VOD-Project/recon/current-state-machine-definition.json

### Step 2 — Read the ASL

cat /home/jcane/Documents/VOD-Project/stepfunctions/vod-localization-pipeline-v2.json

File confirmed. ASL v2 was complete with 7 languages, Map loop, English bypass, Polly wiring.

### Step 3 — Check Recent Executions

aws stepfunctions list-executions
--state-machine-arn arn:aws:states:us-east-1:980049663300:stateMachine:Fixyachips-VOD-Localization-Multi-Language-Pipeline
--max-results 3
--query 'executions[*].{name:name,status:status,executionArn:executionArn}'

All 3 recent executions showed FAILED status.

### Step 4 — Read Last Execution Input

aws stepfunctions get-execution-history
--execution-arn arn:aws:states:us-east-1:980049663300:execution:Fixyachips-VOD-Localization-Multi-Language-Pipeline:b14837fc-afff-4e03-a570-c4bde4fbd0d9
--query 'events[0].executionStartedEventDetails.input'

Output revealed input uses:
- jobName
- videoSourcePath  (full S3 URI already built)
- destinationTutorialPath

ASL was using $.videoKey — MISMATCH FOUND

---

## ERROR 1 — videoSourcePath vs videoKey

**Cause:** ASL built with $.videoKey. Pipeline input sends videoSourcePath which is already a full S3 URI.
**Impact:** Pipeline failed immediately on StartTranscribeJob with JsonPath not found error.

### Fix

sed -i 's/\.videoKey/.videoKey/\\.videoKey/.videoSourcePath/g'
/home/jcane/Documents/VOD-Project/stepfunctions/vod-localization-pipeline-v2.json

sed did not catch the States.Format wrapper. Used Python script instead:

cat > /tmp/fix_asl.py << 'PYEOF' with open('/home/jcane/Documents/VOD-Project/stepfunctions/vod-localization-pipeline-v2.json', 'r') as f: content = f.read() content = content.replace( "States.Format('s3://videoondemandfixyachips-source71e471f1-wlr7kazkufmk/source/{}', $.videoSourcePath)", "$.videoSourcePath" ) content = content.replace('"videoKey.$"', '"videoSourcePath.$"') with open('/home/jcane/Documents/VOD-Project/stepfunctions/vod-localization-pipeline-v2.json', 'w') as f: f.write(content) print('Done') PYEOF python3 /tmp/fix_asl.py

Verified with grep — all 4 references updated to $.videoSourcePath.

### Deploy

aws stepfunctions update-state-machine
--state-machine-arn arn:aws:states:us-east-1:980049663300:stateMachine:Fixyachips-VOD-Localization-Multi-Language-Pipeline
--definition file:///home/jcane/Documents/VOD-Project/stepfunctions/vod-localization-pipeline-v2.json
--role-arn arn:aws:iam::980049663300:role/service-role/StepFunctions-Fixyachips-VOD-Localization-Multi-L-role-vngelb10u

Result: updateDate confirmed, revisionId: 1342ee68-32c7-4dad-9d5e-f0d59603286d

---

## ERROR 2 — Lambda body error

**Execution:** a5789952-f133-4c0d-910f-ec683cb0275f
**Error:** Failed to extract transcript: 'body'
**Cause:** extract_transcript.py was written for API Gateway which wraps input in a body key.
Step Functions invokes Lambda directly — no body wrapper exists.
Lambda also was not fetching from S3 at all — expected transcript JSON to be passed in directly.

### Fix — Rewrote Lambda

cat > /tmp/extract_transcript_fixed.py << 'PYEOF' import json import logging import boto3

logger = logging.getLogger() logger.setLevel(logging.INFO)

s3 = boto3.client('s3')

def lambda_handler(event, context): try: bucket = event['transcriptBucket'] key = event['transcriptKey'] response = s3.get_object(Bucket=bucket, Key=key) data = json.loads(response['Body'].read().decode('utf-8')) transcript_text = data['results']['transcripts'][0]['transcript'] # validation and confidence scoring logic retained return { 'transcriptText': transcript_text, 'characterCount': len(transcript_text), 'validationIssues': [], 'lowConfidenceWordCount': 0 } except Exception as e: raise Exception(f"Failed to extract transcript: {str(e)}") PYEOF

cd /tmp && zip extract_transcript_fixed.zip extract_transcript_fixed.py

aws lambda update-function-code
--function-name fixyachips-extract-transcript
--zip-file fileb:///tmp/extract_transcript_fixed.zip

---

## ERROR 3 — Lambda handler name mismatch

**Cause:** New file named extract_transcript_fixed.py but handler still pointed to extract_transcript.lambda_handler
**Fix:**

aws lambda update-function-configuration
--function-name fixyachips-extract-transcript
--handler extract_transcript_fixed.lambda_handler

---

## ERROR 4 — Lambda timeout too short

**Cause:** Timeout was 3 seconds. S3 fetch and JSON parse requires more time.
**Fix:**

aws lambda update-function-configuration
--function-name fixyachips-extract-transcript
--timeout 30

---

## ERROR 5 — LambdaVODRole missing S3 read permission

**Execution:** a5789952
**Error:** AccessDenied on s3:GetObject for transcript file
**Cause:** LambdaVODRole had no S3 read permissions
**Fix:**

aws iam attach-role-policy
--role-name LambdaVODRole
--policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess

---

## ERROR 6 — AAC bitrate invalid for MediaConvert

**Execution:** cb14e7d4
**Error:** Bitrate 96000 not valid with CODING_MODE_2_0 and sample rate 22050
**Cause:** Invalid AAC encoding combination in both RunMediaConvertEnglish and RunMediaConvertPolly
**Fix:**

sed -i 's/"Bitrate": 96000/"Bitrate": 32000/g'
/home/jcane/Documents/VOD-Project/stepfunctions/vod-localization-pipeline-v2.json

Verified lines 296 and 378 both updated to 32000.
Deployed updated ASL — revisionId: 0f3c8a2a

---

## ERROR 7 — Polly OutputUri is HTTPS not S3 URI

**Execution:** cb14e7d4 and fa66b0c6
**Error:** 3403 Access Forbidden on https://s3.us-east-1.amazonaws.com/...polly....mp3
**Cause:** Polly returns OutputUri as HTTPS URL. MediaConvert requires s3:// URI format.
**Root cause confirmed by reading execution history:**

aws stepfunctions get-execution-history
--execution-arn arn:aws:states:us-east-1:980049663300:execution:...:cb14e7d4-...
--query 'events[?type==TaskSucceeded].taskSucceededEventDetails.output'

Polly OutputUri confirmed as: https://s3.us-east-1.amazonaws.com/bucket/polly/execution/es/.taskId.mp3

**Fix — Added ConvertPollyUri Pass state:**

cat > /tmp/fix_asl_polly_uri.py << 'PYEOF' import json with open('...vod-localization-pipeline-v2.json', 'r') as f: asl = json.load(f)

convert_state = { "Type": "Pass", "Parameters": { "pollyS3Uri.$": "States.Format('s3://videoondemandfixyachips-destination920a3c57-ykrxy0jwcztr/polly/{}/{}/{}', $$.Execution.Name, $.languageShort, States.ArrayGetItem(States.StringSplit($.pollyStatus.SynthesisTask.OutputUri, '/'), 7))", ...all other fields passed through... }, "ResultPath": "$", "Next": "RunMediaConvertPolly" }
Wired IsPollyComplete completed path to ConvertPollyUri
Updated RunMediaConvertPolly ExternalAudioFileInput to use $.pollyS3Uri

PYEOF python3 /tmp/fix_asl_polly_uri.py

Also added MediaConvert read permission on destination bucket:

aws iam put-role-policy
--role-name Fixyachips-App-V1-MediaConvertRole-E0dMye487z6W
--policy-name MediaConvertReadDestinationBucket
--policy-document '{ "Version": "2012-10-17", "Statement": [{ "Effect": "Allow", "Action": ["s3:GetObject", "s3:ListBucket"], "Resource": [ "arn:aws:s3:::videoondemandfixyachips-destination920a3c57-ykrxy0jwcztr", "arn:aws:s3:::videoondemandfixyachips-destination920a3c57-ykrxy0jwcztr/*" ] }] }'

---

## ERROR 8 — ArrayGetItem index wrong — filename resolving to null

**Execution:** fa66b0c6
**Error:** Path resolving to /polly/execution/es/null — filename was null
**Cause:** Hardcoded index 8 was wrong. Step Functions StringSplit skips empty strings
so the empty string between https: and s3.amazonaws.com disappears, shifting all indices.
Tried index 8, then 7, then 6 — all wrong for the same reason.

**Fix — Use ArrayLength minus 1 to always get last element:**

cat > /tmp/fix_index4.py << 'PYEOF' with open('...vod-localization-pipeline-v2.json', 'r') as f: content = f.read() old = "States.ArrayGetItem(States.StringSplit($.pollyStatus.SynthesisTask.OutputUri, '/'), 7)" new = "States.ArrayGetItem(States.StringSplit($.pollyStatus.SynthesisTask.OutputUri, '/'), States.MathAdd(States.ArrayLength(States.StringSplit($.pollyStatus.SynthesisTask.OutputUri, '/')), -1))" content = content.replace(old, new) with open('...vod-localization-pipeline-v2.json', 'w') as f: f.write(content) print('Done') PYEOF python3 /tmp/fix_index4.py

Deployed — revisionId: 29667634

---

## FINAL SUCCESSFUL EXECUTION

**Execution ARN:** arn:aws:states:us-east-1:980049663300:execution:Fixyachips-VOD-Localization-Multi-Language-Pipeline:5e726f50-87ab-430a-81bc-364288b1ec31
**Start:** Nov 21 2026 21:04:02
**End:** Nov 21 2026 21:06:38
**Duration:** 2 minutes 36 seconds
**Status:** SUCCEEDED
**State transitions:** 67

### Output Files Confirmed in S3

aws s3 ls s3://videoondemandfixyachips-destination920a3c57-ykrxy0jwcztr/videos/5e726f50-87ab-430a-81bc-364288b1ec31/ --recursive

2026-11-21 21:05:46 40001088 videos/.../de/5e726f50-...-de.mp4 2026-11-21 21:04:51 40001211 videos/.../en/5e726f50-...-en.mp4 2026-11-21 21:05:06 40004114 videos/.../es/5e726f50-...-es.mp4 2026-11-21 21:05:36 40000879 videos/.../fr/5e726f50-...-fr.mp4 2026-11-21 21:05:48 40000685 videos/.../it/5e726f50-...-it.mp4 2026-11-21 21:06:26 40001277 videos/.../pl/5e726f50-...-pl.mp4 2026-11-21 21:05:04 40004308 videos/.../pt/5e726f50-...-pt.mp4

7 languages. 7 MP4 files. All confirmed.

---

## Confirmed Working ARNs and Values

STATE_MACHINE_ARN=arn:aws:states:us-east-1:980049663300:stateMachine:Fixyachips-VOD-Localization-Multi-Language-Pipeline
STEP_FUNCTIONS_ROLE=arn:aws:iam::980049663300:role/service-role/StepFunctions-Fixyachips-VOD-Localization-Multi-L-role-vngelb10u
MEDIACONVERT_QUEUE=arn:aws:mediaconvert:us-east-1:980049663300:queues/FixyachipsVODQueue-Fixyachips-App-V1
MEDIACONVERT_ROLE=arn:aws:iam::980049663300:role/Fixyachips-App-V1-MediaConvertRole-E0dMye487z6W
SOURCE_BUCKET=videoondemandfixyachips-source71e471f1-wlr7kazkufmk
DESTINATION_BUCKET=videoondemandfixyachips-destination920a3c57-ykrxy0jwcztr
LAMBDA_FUNCTION=fixyachips-extract-transcript
LAMBDA_HANDLER=extract_transcript_fixed.lambda_handler
LAMBDA_TIMEOUT=30
LAMBDA_ROLE=LambdaVODRole

---

## Next Session
- Load real production videos through the pipeline
- Verify audio quality on localized MP4 files
- Pursue AWS Marketplace listing
- Apply for AWS Partner Network
- Build intake mechanism for video uploads

