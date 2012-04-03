# Setup SDK for ruby : https://github.com/amazonwebservices/aws-sdk-for-ruby

require '../aws_config'
require './constants'

# This script is to create a demo for s3 for Amazon seminar at KMS. The demo has:
#	- A new bucket with policy to allow anonymous user to download only
#	- A new bucket with policy to allow anonymous user to list only

# get an instance of the S3 interface
s3 = AWS::S3.new :s3_endpoint => "s3-#{LOCATION}.amazonaws.com"

begin
	if !s3.buckets[DOWNLOAD_BUCKET_NAME].exists? and !s3.buckets[LIST_BUCKET_NAME].exists? 
		b_download = s3.buckets.create DOWNLOAD_BUCKET_NAME
		b_list = s3.buckets.create LIST_BUCKET_NAME
		
		# Upload files
		['down01.jpg', 'down02.jpg', 'down03.jpg'].each { |file_name| 
			basename = File.basename(file_name)
			o = b_download.objects[basename]
			o.write(:file => file_name)
		}
		
		['list01.jpg', 'list02.jpg', 'list03.jpg'].each { |file_name| 
			basename = File.basename(file_name)
			o = b_list.objects[basename]
			o.write(:file => file_name)
		}

		# Apply policy
		b_download.policy = <<ABC
{
  "Id": "Policy1331800817445",
  "Statement": [
    {
      "Sid": "Stmt1331800813637",
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::#{DOWNLOAD_BUCKET_NAME}/*",
      "Principal": {
        "AWS": [
          "*"
        ]
      }
    }
  ]
}
ABC
		b_list.policy = <<ABC
{
  "Id": "Policy1331800817446",
  "Statement": [
    {
      "Sid": "Stmt1331801022778",
      "Action": [
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::#{LIST_BUCKET_NAME}",
      "Principal": {
        "AWS": [
          "*"
        ]
      }
    }
  ]
}
ABC
		
		puts "Created and uploaded file to below buckets:"
		puts "	- #{b_download.url}: allow downloading (not listing). Links:"
		b_download.objects.each do |o|
			puts "		+ #{o.public_url :secure => false}"
		end		
		puts "	- #{b_list.url}: allow listing. Can't download below items:"
		b_list.objects.each do |o|
			puts "		+ #{o.public_url :secure => false}"
		end	
	else
		puts "There is already buckets named #{DOWNLOAD_BUCKET_NAME} or #{LIST_BUCKET_NAME} on region #{LOCATION}. This demo script can't run"
	end
rescue AWS::S3::Errors::MalformedPolicy => e
	puts "Can't put policy on bucket. Error: #{e.message}"
rescue ArgumentError => e
	puts "Can't create bucket. Error: #{e.message}"
rescue AWS::S3::Errors::InvalidBucketName => e
	puts "Invalid bucket name '#{e.message}': "+e.message
rescue AWS::S3::Errors::NoSuchBucket => e
	puts "Can't find bucket. Error: "+e.message
end