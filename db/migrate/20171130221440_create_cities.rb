class CreateCities < ActiveRecord::Migration[5.1]
  def change
    create_table :cities do |t|
      t.string  :department_name
      t.string  :department_code, limit: 3
      t.string   :name
      t.string   :normalized_name
      t.string   :zipcode, limit: 5
      t.string   :insee, limit: 5
      t.decimal  :latitude
      t.decimal  :longitude

      t.timestamps
    end
    add_index :cities, :zipcode
    add_index :cities, :department_code

    add_reference :users, :city
  end
end
