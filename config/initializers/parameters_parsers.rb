original_parsers = ActionDispatch::Request.parameter_parsers
json_parser = -> (raw_post) do
  data = ActiveSupport::JSON.decode(raw_post)
  data.is_a?(Hash) ? data.convert_keys_to_underscore : { _json: data }
end
new_parsers = original_parsers.merge(Mime[:json].symbol => json_parser)
ActionDispatch::Request.parameter_parsers = new_parsers