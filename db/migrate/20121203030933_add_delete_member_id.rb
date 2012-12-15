class AddDeleteMemberId < ActiveRecord::Migration
  def change
  	add_column :members, :delete_id, :integer
  end
end
