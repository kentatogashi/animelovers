class CreateAnimes < ActiveRecord::Migration
  def change
    create_table :animes do |t|
      t.string :title
      t.string :days_of_the_week
      t.time :start_time

      t.timestamps null: false
    end
  end
end
