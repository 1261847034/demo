class CreateSimditorArticles < ActiveRecord::Migration
  def change
    create_table :simditor_articles do |t|
      t.string :content
      t.timestamps null: false
    end
  end
end
