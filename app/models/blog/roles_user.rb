# frozen_string_literal: true

module Blog
  class RolesUser < Base
    belongs_to :user
    belongs_to :role, class_name: "Blog::Role"
  end
end
