class String

  def to_lower_camelcase
    self.camelcase(:lower)
  end

end

class Hash

  def convert_keys_to_camelcase
    pristine = self.dup

    self.transform_keys! do |k|
      current_val = pristine[k]

      if current_val.is_a?(Hash)
        current_val.convert_keys_to_camelcase
      elsif current_val.is_a?(Array)
        current_val.each do |item|
          if item.is_a?(Hash)
            item.convert_keys_to_camelcase
          end
        end
      end

      k.to_s.to_lower_camelcase
    end
  end

  def convert_keys_to_underscore
    pristine = self.dup

    self.transform_keys! do |k|
      current_val = pristine[k]

      if current_val.is_a?(Hash)
        current_val.convert_keys_to_underscore
      elsif current_val.is_a?(Array)
        current_val.each do |item|
          if item.is_a?(Hash)
            item.convert_keys_to_underscore
          end
        end
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