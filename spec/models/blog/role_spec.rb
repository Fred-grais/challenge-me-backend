require 'rails_helper'

RSpec.describe Blog::Role, type: :model do
    describe 'Associations' do
      it {should have_many(:roles_users).class_name('Blog::RolesUser')}
    end
end