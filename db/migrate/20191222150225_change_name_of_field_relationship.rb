class ChangeNameOfFieldRelationship < ActiveRecord::Migration[6.0]
  def change
    rename_column :relationships, :follewed_id, :followed_id
  end
end
