Rails.application.config.middleware.use OmniAuth::Builder do
  provider :linkedin, ENV['LINKEDIN_KEY'], ENV['LINKEDIN_SECRET'], redirect_uri: 'http://localhost:3000/auth/linkedin/callback', secure_image_url: true
end