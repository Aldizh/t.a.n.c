class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string :status
      t.string :email
      t.string :password
      t.string :member_type
      t.boolean :confirmed
      t.timestamps
    end
  end
end
