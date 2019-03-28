module Blog

  class Base < ActiveRecord::Base
    self.abstract_class = true
    establish_connection GHOST_DATABASE
  end
end