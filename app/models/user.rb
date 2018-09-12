class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  include DeviseTokenAuth::Concerns::User
  include FrontDataGeneration

  has_many :projects

  PREVIEW_ATTRIBUTES = {
      attributes: [:id, :first_name, :last_name, :position],
      methods: []
  }

  FULL_ATTRIBUTES = {
      attributes: [:id, :email, :first_name, :last_name, :position],
      methods: []
  }

  PROJECT_ATTRIBUTES_PREVIEW = {
      attributes: [:id, :first_name, :last_name, :position],
      method: []
  }

  # def as_json(options)
  #   json = if options[:preview].present?
  #            super(only: PREVIEW_ATTRIBUTES)
  #          else
  #            super(only: FULL_ATTRIBUTES)
  #          end
  #
  #   options[:for_front].present? ? json.convert_keys_to_camelcase : json
  # end
end
