class AddAdmin < ActiveRecord::Migration
  def change
    add_column :members, :admin, :boolean
  end
end
