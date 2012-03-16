require '../aws_config'
require './constants.rb'


# Gets an instance of the SQS interface using the default configuration
sqs = AWS::SQS.new
begin
	q = sqs.queues.named QUEUE_NAME
	found = false
	q.receive_message { |m|
		puts "Processing the message. Body: #{m.body}"
		sleep 20
		puts "Message is deleted"
		found = true
	}
	puts "Found no message on queue #{QUEUE_NAME} on region #{LOCATION_NAME}" unless found
rescue AWS::SQS::Errors::NonExistentQueue 
	puts "No queue '#{QUEUE_NAME}' is found on AWS - region #{LOCATION_NAME}"
end