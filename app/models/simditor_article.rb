class SimditorArticle < ActiveRecord::Base
  validates :content, presence: true
end
