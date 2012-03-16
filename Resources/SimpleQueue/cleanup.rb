require '../aws_config'
require './constants.rb'

# Gets an instance of the SQS interface using the default configuration
sqs = AWS::SQS.new
found = false

sqs.queues.each { |q|
	if /\w+$/.match(q.url).to_s==QUEUE_NAME
		q.delete
		puts "After around 30 seconds, queue '#{QUEUE_NAME}' will be deleted on region #{LOCATION_NAME}"
		found = true
	end
}

puts "No queue '#{QUEUE_NAME}' is found on AWS - region #{LOCATION_NAME}" unless found