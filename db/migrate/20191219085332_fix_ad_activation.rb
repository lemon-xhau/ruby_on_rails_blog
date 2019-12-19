class FixAdActivation < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :activated_ad, :activated_at
  end
end
