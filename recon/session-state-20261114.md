# VOD Pipeline Rebuild Session State
# Status: IAM FIXES COMPLETE — READY TO WRITE STATE MACHINE JSON

## Where We Left Off
Phase 1 recon is complete.
Phase 2 diagnosis is complete.
IAM fixes applied and confirmed.
Next session starts at Phase 3 — Write the corrected state machine JSON.

## What Was Fixed This Session
1. StepFunctions-MediaConvert-S3-Access — PassRole now points to correct MediaConvert role
2. StepFunctions-MediaConvert-S3-Access — S3 permissions now point to correct buckets
3. VODPipelinePermissions — Added polly:StartSpeechSynthesisTask and polly:GetSpeechSynthesisTask
4. MediaConvertS3LeastPrivilege — Now covers source, manuals, and destination buckets correctly

## Confirmed Values — Use These Exactly
STATE_MACHINE_ARN=arn:aws:states:us-east-1:980049663300:stateMachine:Fixyachips-VOD-Localization-Multi-Language-Pipeline
STEP_FUNCTIONS_ROLE=arn:aws:iam::980049663300:role/service-role/StepFunctions-Fixyachips-VOD-Localization-Multi-L-role-vngelb10u
MEDIACONVERT_ENDPOINT=https://mediaconvert.us-east-1.amazonaws.com
MEDIACONVERT_QUEUE=arn:aws:mediaconvert:us-east-1:980049663300:queues/FixyachipsVODQueue-Fixyachips-App-V1
MEDIACONVERT_ROLE=arn:aws:iam::980049663300:role/Fixyachips-App-V1-MediaConvertRole-E0dMye487z6W
SOURCE_BUCKET=videoondemandfixyachips-source71e471f1-wlr7kazkufmk
SOURCE_PREFIX=source/
MANUALS_BUCKET=videoondemandfixyachips-manuals
DESTINATION_BUCKET=videoondemandfixyachips-destination920a3c57-ykrxy0jwcztr
LAMBDA_FUNCTION=fixyachips-extract-transcript
CLOUDFRONT_DISTRIBUTION=E1BVP04I7B9G57

## Voice Mappings — All Male — Locked In
en-US = Matthew (neural)
es-ES = Sergio (neural)
pt-BR = Ricardo (standard)
fr-FR = Remi (neural)
de-DE = Daniel (neural)
it-IT = Adriano (neural)
pl-PL = Jacek (standard)
Swedish = DROPPED

## Output Structure
s3://videoondemandfixyachips-destination920a3c57-ykrxy0jwcztr/videos/JOBNAME/LANGCODE/JOBNAME-LANGCODE.mp4

## What Is Broken in the Current State Machine
1. MediaConvert is OUTSIDE the Map loop — runs once, produces 1 MP4 instead of 7
2. Polly OutputUri never wires into MediaConvert audio input
3. English is missing from the language array
4. MediaConvert was using wrong queue ARN (Default instead of FixyachipsVODQueue)
5. MediaConvert was using wrong IAM role (manual role instead of CloudFormation role)
6. S3 bucket references throughout were pointing to wrong buckets

## What Is Already Correct in the Current State Machine
1. startSpeechSynthesisTask is already being used
2. Polly poll loop exists and works
3. MaxConcurrency 3 is set
4. Transcribe poll loop exists and works
5. Extract transcript Lambda wiring is correct

## CloudFormation Stack
Stack name: Fixyachips-App-V1
Status: UPDATE_COMPLETE
The state machine is NOT in this stack. It was built manually in the console.

## Next Session Bedrock Prompt
I am JCane continuing the VOD pipeline rebuild.
IAM fixes are complete and confirmed from the previous session.
I need you to write the corrected Step Functions ASL JSON for Phase 3.
Use only the confirmed values in this document.
Do not ask me to rerun recon. Everything is here.
The state machine has 7 languages. Swedish is dropped.
MediaConvert must be inside the Map loop.
Polly uses startSpeechSynthesisTask already — keep it.
Wire $.pollyStatus.OutputUri into MediaConvert ExternalAudioFileInput.
English uses a Choice bypass — skip Translate and Polly, use original video audio directly.
All other 6 languages go through Translate then Polly then MediaConvert.
MaxConcurrency stays at 3.
Use FixyachipsVODQueue not the Default queue.
Output structure is videos/jobname/languageCode/jobname-languageCode.mp4
Do not generate CloudFormation. Do not reference eu-west-1. Write the ASL JSON only.
