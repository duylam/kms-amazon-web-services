require 'aws-sdk'

authentication_config = {
	:access_key_id => 'YOUR_ACCESS_KEY_ID',
	:secret_access_key => 'YOUR_SECRET_ACCESS_KEY'
}

AWS.config(authentication_config)