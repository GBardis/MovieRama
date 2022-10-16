class CreateMovies < ActiveRecord::Migration[6.1]
  def change
    create_table :movies do |t|
      t.string :title
      t.text :description
      t.string :user_name

      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
