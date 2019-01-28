import json
import boto3
import os
# Create a new SES resource and specify a region.
PROD_CLIENT = boto3.client('ses', 'us-east-1')
def sendemails(event, context):
# Try to send the email.
    #Provide the contents of the email.
    PROD_CLIENT= boto3.client('ses', 'us-east-1')
    accessfilterlist= event["filterList"]
    accessfiltervalue = event["filterValue"]
    if accessfiltervalue in accessfilterlist:
        response = PROD_CLIENT.send_email(
            Source= event["sender"],
            Destination={
                'ToAddresses': event["recipients"],
            },
            Message={
                'Subject': {
                    'Data': event["subject"],
                    'Charset': 'UTF-8',
                },
                'Body': {
                    'Text': {
                        'Data': event["mailbody"],
                        'Charset': 'UTF-8',
                    },
                    'Html': {
                        'Data': event["mailbody"],
                        'Charset': 'UTF-8',
                    }
                }
            },
            ReplyToAddresses=[
                "donotreply@eduphoria.net"
            ],
        )
        return {
            "Response" : response
        }
