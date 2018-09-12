module FrontDataGeneration
  extend ActiveSupport::Concern

  def as_json(options = {})
    json = if options[:preview].present?
             super(only: self.class::PREVIEW_ATTRIBUTES[:attributes], methods: self.class::PREVIEW_ATTRIBUTES[:methods])
           else
             super(only: self.class::FULL_ATTRIBUTES[:attributes], methods: self.class::FULL_ATTRIBUTES[:methods])
           end

    options[:for_front].present? ? json.convert_keys_to_camelcase : json
  end

end
