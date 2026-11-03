import json
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    try:
        body = event['body']
        data = json.loads(body)

        transcript_text = data['results']['transcripts'][0]['transcript']

        issues = []

        if not transcript_text:
            raise ValueError("transcriptText is empty after extraction")

        if len(transcript_text) > 10000:
            issues.append({
                "type": "TEXT_TOO_LONG",
                "originalLength": len(transcript_text),
                "action": "TRUNCATED_TO_10000"
            })
            transcript_text = transcript_text[:10000]

        if len(transcript_text) < 10:
            issues.append({
                "type": "TEXT_TOO_SHORT",
                "length": len(transcript_text),
                "action": "FLAGGED"
            })

        if issues:
            logger.warning(json.dumps({
                "event": "TRANSCRIPT_VALIDATION_ISSUES",
                "issuesFound": issues,
                "finalLength": len(transcript_text)
            }))
        else:
            logger.info(json.dumps({
                "event": "TRANSCRIPT_EXTRACTED_CLEAN",
                "finalLength": len(transcript_text)
            }))

        words = data['results'].get('items', [])
        low_confidence = [
            w for w in words
            if w.get('type') == 'pronunciation'
            and float(w.get('alternatives', [{}])[0].get('confidence', 1)) < 0.5
        ]

        if low_confidence:
            logger.warning(json.dumps({
                "event": "LOW_CONFIDENCE_WORDS_DETECTED",
                "count": len(low_confidence),
                "samples": low_confidence[:5]
            }))

        return {
            'transcriptText': transcript_text,
            'characterCount': len(transcript_text),
            'validationIssues': issues,
            'lowConfidenceWordCount': len(low_confidence)
        }

    except Exception as e:
        raise Exception(f"Failed to extract transcript: {str(e)}")
