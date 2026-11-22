# 100 Step Functions Interview Questions and Answers
# Prepared for JCane — KANSHOIAC.DEV VOD Localization Pipeline
# November 21 2026
# Format: What they are really asking / How it works and why / Your 60-90 second spoken script / Likely follow-ups


## SECTION 1 — Step Functions Core Architecture (Questions 1-20)

### Question 1
**What is the difference between Standard and Express Step Functions workflows and when do you choose each?**

**What they are really asking:**
Do you actually understand the billing model and durability tradeoffs or did you just pick one randomly?

**How it works and why:**
Standard workflows bill per state transition, support executions up to one year, are exactly-once execution, and store full execution history in the console. Express workflows bill per duration and number of executions, run up to five minutes, are at-least-once execution, and do not store history natively. Standard is for long-running durable pipelines. Express is for high-volume short-duration event processing.

**Your 60-90 second spoken script:**
"I chose Standard for my VOD localization pipeline because a single video takes between two and ten minutes end to end. Standard handles that reliably with exactly-once execution guarantees and full execution history I can inspect in the console. Express would have been wrong here — five minute max duration would cut off mid-pipeline on longer videos, and at-least-once execution means I could end up with duplicate Transcribe jobs or duplicate MediaConvert outputs. The cost tradeoff is real — Standard bills per state transition and my pipeline burns 67 transitions per video — but for enterprise video content durability beats cost optimization at this scale."

**Likely follow-ups:**
- What does exactly-once execution mean in practice?
- How would you reduce state transition costs in your polling loops?
- When would you use Express over Standard?


### Question 2
**Walk me through the architecture of your asynchronous Step Functions pipeline integrating MediaConvert, Transcribe, Translate, and Polly.**

**What they are really asking:**
Can you explain a real system you built clearly and concisely without getting lost in the weeds?

**How it works and why:**
One English video lands in S3. Step Functions orchestrates four AWS AI services in sequence and parallel. Transcribe converts speech to text asynchronously via a polling loop. A Lambda extracts the clean transcript text from the JSON output stored in S3. A Map state fans out across seven languages with MaxConcurrency 3. English bypasses translation via a Choice state. The other six go through Translate then Polly asynchronously. A ConvertPollyUri Pass state converts the Polly HTTPS output URI to an S3 URI. MediaConvert uses a native dot-sync integration to mux the original video with the localized audio into seven MP4 files in S3.

**Your 60-90 second spoken script:**
"One English training video lands in S3 and seven localized MP4s come out automatically in under three minutes without touching a server. First it starts a Transcribe job asynchronously and enters a Wait and CheckTranscribeStatus polling loop every 30 seconds. When complete a Lambda reads the transcript JSON from S3 and extracts the clean text. Then a Map state capped at MaxConcurrency 3 fans out across seven languages — English bypasses translation via a Choice state while the other six go through Translate then Polly startSpeechSynthesisTask with a 15-second polling loop. A ConvertPollyUri Pass state converts Polly's HTTPS output URI to an S3 URI because MediaConvert only accepts S3 URIs. Finally each branch calls MediaConvert using dot-sync to mux the video with the localized audio. First fully green run was execution 5e726f50 — two minutes 36 seconds, 67 state transitions, seven MP4 files all approximately 40 megabytes each."

**Likely follow-ups:**
- Why MaxConcurrency 3 and not 7?
- Why did you use startSpeechSynthesisTask instead of SynthesizeSpeech?
- How did you handle the Polly URI format mismatch?

