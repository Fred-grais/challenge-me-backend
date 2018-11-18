module Api
  module V1
    class TagsController < Api::ApiV1Controller
      before_action :authenticate_user!

      def index
        render json: {result: ActsAsTaggableOn::Tag.where('name LIKE ?', "%#{params[:search]}%").limit(10).map{ |tag| {text: tag.name}}}
      end

    end
  end
end