# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'localhost:8080', '192.168.1.21:8080', 'challenge-me.now.sh'


    resource '/projects',
             headers: :any,
             methods: [:get, :options]

    resource '/projects/*',
             headers: :any,
             methods: [:get, :options]

    resource '/users',
             headers: :any,
             methods: [:get, :options]

    resource '/users/*',
             headers: :any,
             methods: [:get, :options]

    resource '/podcasts',
             headers: :any,
             methods: [:get, :options]


    resource '/api/*/tags',
             headers: :any,
             expose: ['access-token', 'expiry', 'token-type', 'uid', 'client'],
             methods: [:get, :options]

    resource '/api/*/users',
             headers: :any,
             expose: ['access-token', 'expiry', 'token-type', 'uid', 'client'],
             methods: [:get, :options]

    resource '/api/*/me/projects/*',
             headers: :any,
             expose: ['access-token', 'expiry', 'token-type', 'uid', 'client'],
             methods: [:get, :post, :put, :patch, :delete, :options]

    resource '/api/*/me/projects',
             headers: :any,
             expose: ['access-token', 'expiry', 'token-type', 'uid', 'client'],
             methods: [:get, :post, :put, :patch, :delete, :options]

    resource '/api/*/me/conversations',
             headers: :any,
             expose: ['access-token', 'expiry', 'token-type', 'uid', 'client'],
             methods: [:get, :post, :options]

    resource '/api/*/me/chat_sessions',
             headers: :any,
             expose: ['access-token', 'expiry', 'token-type', 'uid', 'client'],
             methods: [:post, :options]

    resource '/api/*/me/messages',
             headers: :any,
             expose: ['access-token', 'expiry', 'token-type', 'uid', 'client'],
             methods: [:post, :options]

    resource '/api/*/me/conversations/*',
             headers: :any,
             expose: ['access-token', 'expiry', 'token-type', 'uid', 'client'],
             methods: [:get, :options]

    resource '/me',
             headers: :any,
             expose: ['access-token', 'expiry', 'token-type', 'uid', 'client'],
             methods: [:get, :put, :patch, :options]

    resource '/me/*',
             headers: :any,
             expose: ['access-token', 'expiry', 'token-type', 'uid', 'client'],
             methods: [:get, :options]

    resource '/auth',
             headers: :any,
             expose: ['access-token', 'expiry', 'token-type', 'uid', 'client'],
             methods: [:get, :post, :put, :patch, :options, :head]

    resource '/auth/*',
      headers: :any,
      expose: ['access-token', 'expiry', 'token-type', 'uid', 'client'],
      methods: [:get, :post, :put, :patch, :options, :head]
  end
end
