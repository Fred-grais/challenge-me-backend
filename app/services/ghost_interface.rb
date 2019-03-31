# frozen_string_literal: true

class GhostInterface
  include HTTParty
  base_uri ENV['GHOST_API_BASE_URL']

  class GhostInterfaceError < StandardError
  end

  class ResponseError < GhostInterfaceError
  end

  def initialize(credentials)
    @credentials = credentials
  end

  def create_session
    response = self.class.post('/v2/admin/session',
                               headers: {
                                 origin: 'http://blog.challenge-me.dev.com:4001'
                               },
                               query: {
                                 username: @credentials.username,
                                 password: @credentials.password
                               })

    unless response.code == 201
      raise ResponseError, "Error calling #{__method__} => status #{response.code} with body #{response.parsed_response}"
    end

    response.headers['set-cookie']
  end
end
