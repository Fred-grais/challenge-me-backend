require 'rails_helper'

RSpec.describe Blog::RolesUser, type: :model do
    describe 'Associations' do
      it {should belong_to(:user)}
      it {should belong_to(:role).class_name('Blog::Role')}
    end
end