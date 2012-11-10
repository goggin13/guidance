require 'pusher'

config = "#{Rails.root.to_s}/config/app.yml"

if File.exist?(config)
 raw_settings = YAML.load(ERB.new(File.read(config)).result)
 APP = raw_settings[Rails.env]
end

Pusher.app_id = APP['pusher_app_id']
Pusher.key = APP['pusher_api_key']
Pusher.secret = APP['pusher_api_secret']

