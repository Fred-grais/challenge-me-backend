# frozen_string_literal: true

class RocketChatInterface
  class RocketChatError < StandardError
  end

  class UserCreationError < RocketChatError
  end

  class UserInfoError < RocketChatError
  end

  def initialize
    connect_to_server

    open_admin_session
  end

  def create_user(user)
    full_name = user.full_name

    begin
      @session.users.create(generate_name(full_name), user.email, full_name, SecureRandom.hex(16),
                            active: true, send_welcome_email: false, join_default_channels: true, custom_fields: { app_user_id: user.id })
    rescue StandardError => e
      raise UserCreationError, "#{e.message} for user #{user.id}"
    end
  end

  def get_user(id)
    @session.users.info(user_id: id)
  rescue StandardError => e
    raise UserInfoError, "#{e.message} for user #{id}"
  end

  def list_groups
    @session.groups.list
  rescue StandardError => e
    raise RocketChatError, "#{e.message} when listing private rooms"
  end

  def get_group(group_id)
    @session.groups.info(room_id: group_id)
  rescue StandardError => e
    raise RocketChatError, "#{e.message} when listing group #{group_id}"
  end

  def create_group(name)
    @session.groups.create(generate_name(name))
  rescue StandardError => e
    raise RocketChatError, "#{e.message} when creating group <#{name}>"
  end

  def delete_group(group_id)
    @session.groups.delete(room_id: group_id)
  rescue StandardError => e
    raise RocketChatError, "#{e.message} when deleting group #{group_id}"
  end

  def add_owner_to_group(group_id, owner_id)
    @session.groups.add_owner(room_id: group_id, user_id: owner_id)
  rescue StandardError => e
    raise RocketChatError, "#{e.message} when adding owner #{owner_id} to group #{group_id}"
  end

  def add_moderator_to_group(group_id, moderator_id)
    @session.groups.add_moderator(room_id: group_id, user_id: moderator_id)
  rescue StandardError => e
    raise RocketChatError, "#{e.message} when adding moderator #{moderator_id} to group #{group_id}"
  end

  def generate_auth_token_for_user(rocket_chat_user_id)
    @session.users.create_token(user_id: rocket_chat_user_id)
  rescue StandardError => e
    raise RocketChatError, "#{e.message} when generating token for user #{rocket_chat_user_id}"
  end

  private

  def generate_name(full_name)
    full_name.gsub(/\s+/, '').underscore
  end

  def connect_to_server
    @server = RocketChat::Server.new(ENV['ROCKET_CHAT_SERVER_URL'])
  end

  def open_admin_session
    @session = @server.login(ENV['ROCKET_CHAT_ADMIN_USERNAME'], ENV['ROCKET_CHAT_ADMIN_PASSWORD'])
  end
end
