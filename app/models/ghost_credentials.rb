class GhostCredentials < ApplicationRecord

  attr_reader :interface

  belongs_to :user
  has_one :blog_user, class_name: 'Blog::User', foreign_key: :id

  after_initialize :set_ghost_interface
  after_create :create_user_in_ghost_db

  validates_presence_of :username, :password

  delegate :create_session, to: :interface

  private

    def set_ghost_interface
      @interface = GhostInterface.new(self)
    end

    def create_user_in_ghost_db
      new_user = Blog::User.new(
        id: self.id,
        name: self.user.full_name,
        slug: self.user.full_name.parameterize,
        password: self.password,
        email: self.user.email,
        accessibility: '{"nightShift":true}',
        status: :active,
        visibility: :public,
        created_at: DateTime.now,
        created_by: 1,
        ghost_credentials: self
      )

      new_roles_user = new_user.role = Blog::RolesUser.new(
        id: self.id
      )

      new_roles_user.role = Blog::Role.find_by(name: 'Contributor')

      new_user.save
    end
end
