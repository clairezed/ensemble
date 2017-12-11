class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.references :user, index: true, foreign_key: true
      t.references :leisure_category, index: true, foreign_key: true
      t.references :leisure, index: true, foreign_key: true
      t.references :city, index: true, foreign_key: true
      t.string   :title
      t.string   :address
      t.integer   :participants_min
      t.integer   :participants_max
      t.integer   :visibility, default: 0
      t.integer   :state, default: 0
      t.integer   :affiliation, default: 0
      t.text   :description
      t.datetime  :start_at
      t.datetime  :end_at

      t.timestamps
    end
  end
end
