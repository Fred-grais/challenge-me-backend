# frozen_string_literal: true

module Blog
  class Role < Base
    has_many :roles_users, class_name: "Blog::RolesUser"
  end
end
