class String

  def to_lower_camelcase
    self.camelcase(:lower)
  end

end

class Hash

  def convert_keys_to_camelcase
    self.keys.each do |k|
      if self[k].is_a?(Hash)
        self[k].convert_keys_to_camelcase
      end

      camelcased_key = k.to_s.to_lower_camelcase

      if camelcased_key != k
        self[camelcased_key] = self[k]
        self.delete(k)
      end
    end

    self
  end

  def convert_keys_to_underscore
    self.transform_keys! do |k|
      if self[k].is_a?(Hash)
        self[k].convert_keys_to_underscore
      end

      k.to_s.underscore
    end
  end
end

class ActionController::Parameters

  def convert_keys_to_underscore
    self.transform_keys! do |k|
      if self[k].is_a?(ActionController::Parameters)
        self[k].convert_keys_to_underscore
      end

      k.underscore
    end
  end

end