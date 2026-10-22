# Architecture Decision — Week 5

## Decision: Step Functions replaces AgentCore for VOD Pipeline

### Problem
AgentCore was recommended as replacement for Step Functions.
This was incorrect advice.

### Why AgentCore is Wrong for This Pipeline
- AgentCore is for conversational AI agents that make decisions
- Cannot orchestrate long-running deterministic media pipelines
- No native wait mechanism for MediaConvert/Transcribe jobs
- 15 minute video processing will always timeout

### Why Step Functions Timed Out Originally
- Timeout was in Lambda NOT in Step Functions
- Fix: use .waitForTaskToken with native SDK integrations
- Step Functions itself has no timeout on long-running jobs

### Required Pipeline
Video → MediaConvert → Transcribe → Translate (6 languages) → Polly → MediaConvert

### Next Session
- Review step functions/ folder
- Build step_functions.tf
- Build step_functions_iam.tf
- terraform apply
