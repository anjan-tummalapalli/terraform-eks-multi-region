import json
import os


def lambda_handler(event, context):
    return {
        "statusCode": 200,
        "body": json.dumps(
            {
                "message": "Hello from Terraform-managed Lambda",
                "stage": os.getenv("STAGE", "unknown"),
            }
        ),
    }
