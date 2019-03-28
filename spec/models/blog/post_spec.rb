require 'rails_helper'

RSpec.describe Blog::Post, type: :model do

    describe 'Associations' do
      it {should belong_to(:user).with_foreign_key(:author_id)}
    end
end