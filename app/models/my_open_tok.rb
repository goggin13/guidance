

class MyOpenTok

  def initialize
    @otsdk = OpenTok::OpenTokSDK.new APP['open_tok_api_key'], APP['open_tok_api_secret']
  end
  
  # session_id (string) - REQUIRED
  # role (string) - OPTIONAL. subscriber, publisher, or moderator
  # expire_time (int) - OPTIONAL. Time when token will expire in unix timestamp
  # connection_data (string) - OPTIONAL. Metadata to store data (names, user id, etc)
  def generate_token(options)
    @otsdk.generateToken options
  end
end