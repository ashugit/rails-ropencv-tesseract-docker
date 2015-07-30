require 'aws-sdk'
# config/initializers/aws-sdk.rb
# AWS_BUCKET
# AWS_ACCESS_KEY_ID
# AWS_ACCESS_KEY_SECRET
# AWS_REGION

Aws.config.update(
  credentials: Aws::Credentials.new( ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_ACCESS_KEY_SECRET']),
  region: ENV['AWS_REGION'])
