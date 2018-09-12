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
end