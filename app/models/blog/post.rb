module Blog
  class Post < Base

    belongs_to :user, foreign_key: :author_id

  end
end