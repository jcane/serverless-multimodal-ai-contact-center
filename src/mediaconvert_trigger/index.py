import json

def handler(event, context):
    return {
        "statusCode": 200,
        "body": json.dumps({"message": "mediaconvert_trigger placeholder"})
    }
