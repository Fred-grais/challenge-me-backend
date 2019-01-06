class RocketChatInterface

  class RocketChatError < StandardError
  end

  class UserCreationError < RocketChatError
  end

  def initialize
    connect_to_server
    open_admin_session
  end

  def create_user(user)
    full_name = user.full_name

    begin
      @session.users.create(generate_username(full_name), user.email, full_name, SecureRandom.hex(16),
                           active: true, send_welcome_email: false, join_default_channels: true, custom_fields: {app_user_id: user.id})
    rescue => e
      raise UserCreationError.new("#{e.message} for user #{user.id}")
    end
  end

  def generate_auth_token_for_user(rocket_chat_user_id)
    @session.users.create_token(user_id: rocket_chat_user_id)
  end

  private

  def generate_username(full_name)
    full_name.gsub(/\s+/, '').underscore
  end

  def connect_to_server
    @server = RocketChat::Server.new(ENV['ROCKET_CHAT_SERVER_URL'])
  end

  def open_admin_session
    @session = @server.login(ENV['ROCKET_CHAT_ADMIN_USERNAME'], ENV['ROCKET_CHAT_ADMIN_PASSWORD'])
  end
end