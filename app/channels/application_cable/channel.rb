module ApplicationCable
  class Channel < ActionCable::Channel::Base

    def params
      @params.convert_keys_to_underscore
    end
  end
end
