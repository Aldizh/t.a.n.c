class AddNonMemberActive < ActiveRecord::Migration
  def change
	add_column :members, :non_member_active, :boolean
  end
end
