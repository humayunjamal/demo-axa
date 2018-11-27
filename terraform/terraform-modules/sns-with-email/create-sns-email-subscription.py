##
## This script creates sns email subscription which is not supported in terraform for now
## because it requires confirmation.
##
## Ref: https://www.terraform.io/docs/providers/aws/r/sns_topic_subscription.html#protocols-supported

import boto3
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("-t", "--topic-arn", dest="topic_arn", help="topic arn", required=True)
parser.add_argument("-e", "--email", help="email", required=True)
parser.add_argument("-p", "--protocol", help="email protocol", required=True)
parser.add_argument("-r", "--region", help="aws region", required=True)
args = parser.parse_args()

class SNSTopic(object):
	def __init__(self, topic_arn,email,protocol,region):
		super(SNSTopic, self).__init__()
		sns = boto3.resource('sns', region_name=region)
		self.topic = sns.Topic(topic_arn)
		self.email = email
		self.protocol = protocol

	def subscribe(self):
		status =  self.exist()
		if not status:
			subscription = self.topic.subscribe(
			    Protocol=self.protocol,
			    Endpoint=self.email
			)
			status = subscription.arn
		return status

	def exist(self):
		for subscription in self.topic.subscriptions.all():
			if subscription.arn in ['PendingConfirmation','Deleted']:
				return subscription.arn
			elif (subscription.attributes['Protocol'] == self.protocol and subscription.attributes['Endpoint'] == email):
				return subscription.arn
		return False

def main():
	result = SNSTopic(topic_arn=args.topic_arn,email=args.email,protocol=args.protocol,region=args.region).subscribe()
	print(result)

if __name__ == '__main__':
	main()