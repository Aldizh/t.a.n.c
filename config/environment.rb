# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Tanc::Application.initialize!

Tanc::Application.config.action_mailer.delivery_method = :smtp
Tanc::Application.config.action_mailer.raise_delivery_errors = true

