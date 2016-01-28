class RedisCachesController < ApplicationController
  def index
    # @articles = Rails.cache.fetch "articles" do
    #   SimditorArticle.all.limit(10).to_a
    # end
    @articles = $redis_store.fetch "articles" do
      SimditorArticle.all.limit(10).to_a
    end
  end
end