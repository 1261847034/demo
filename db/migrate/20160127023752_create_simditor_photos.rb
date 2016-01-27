class CreateSimditorPhotos < ActiveRecord::Migration
  def change
    create_table :simditor_photos do |t|
      t.string :image
      t.timestamps null: false
    end
  end
end
