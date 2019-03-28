# frozen_string_literal: true

module Blog
  class User < Base
    has_one :role, class_name: "Blog::RolesUser", inverse_of: :user, dependent: :destroy
    belongs_to :ghost_credentials, foreign_key: :id, primary_key: :id, class_name: "GhostCredentials"

    has_many :posts, class_name: "Blog::Post", foreign_key: :author_id

    before_create :hash_password

    attr_accessor :name, :slug, :password, :email, :accessibility, :status, :visibility, :created_at, :created_by


    def password_valid?(value)
      BCrypt::Password.new(self.password) == value
    end

    private

      def hash_password
        self.password = BCrypt::Password.create(self.password)
      end
  end
end
