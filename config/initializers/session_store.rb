# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_graylog_session',
  :secret      => 'e4eaac5fc1b0d2d5b0ba581e35ed33f1ba9dad6098414632d9044fe69fa32d31dfddfed1aaadbffa85212567b3766440459a65492b5a68179aa936057658b1aa',
  :expire_after => 31.days
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
