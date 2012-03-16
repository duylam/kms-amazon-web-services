# Setup SDK for ruby : https://github.com/amazonwebservices/aws-sdk-for-ruby

require '../aws_config'
require './constants'

# This script is to clean the demo for s3 for Amazon seminar at KMS

# get an instance of the S3 interface
s3 = AWS::S3.new :s3_endpoint => "s3-#{LOCATION}.amazonaws.com"

begin	
	b_download = s3.buckets[DOWNLOAD_BUCKET_NAME]
	b_list = s3.buckets[LIST_BUCKET_NAME]
	
 	b_download.delete! if b_download.exists?
	b_list.delete! if b_list.exists?
	
	puts "Deleted buckets: #{DOWNLOAD_BUCKET_NAME}, #{LIST_BUCKET_NAME}"
rescue => e
	puts "Can't delete bucket. Error: "+e.message
end