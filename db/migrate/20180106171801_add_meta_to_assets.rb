class AddMetaToAssets < ActiveRecord::Migration[5.1]
  def change
    add_column :assets, :asset_meta, :text
  end
end
