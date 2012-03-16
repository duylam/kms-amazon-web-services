require '../aws_config'
require './constants.rb'

# Gets an instance of the SQS interface using the default configuration
sqs = AWS::SQS.new

begin
	q = sqs.queues.named QUEUE_NAME
	puts "Queue #{QUEUE_NAME} already existed on AWS - region #{LOCATION_NAME}, stop"

rescue AWS::SQS::Errors::NonExistentQueue
	begin
		q = sqs.queues.create QUEUE_NAME, :visibility_timeout => 30	
		loop do	
			if q.exists? 
				q = sqs.queues.named QUEUE_NAME
				['hello 01', 'hello 02', 'hello 03', 'hello 04', 'hello 05', 'hello 05'].each { |m|
					q.send_message m
				}
				puts "Queue '#{QUEUE_NAME}' is created on AWS - region #{LOCATION_NAME}"
				break
			end
			sleep 1
		end
	rescue AWS::SQS::Errors::QueueDeletedRecently
		puts "Run script again after 60 seconds"
	end
end
