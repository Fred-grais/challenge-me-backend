# frozen_string_literal: true

module Api
  module V1
    class UsersController < Api::ApiV1Controller
      def index
        render json: { results: User.select(:first_name, :last_name, :email).where("lower(first_name || ' ' || last_name) LIKE ?", "%#{params[:search].downcase}%").limit(10).map do |user|
          {
            firstName: user.first_name,
            lastName: user.last_name,
            email: user.email
          }
        end }
      end
    end
  end
end
