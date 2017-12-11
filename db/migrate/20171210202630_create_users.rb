class CreateUsers < ActiveRecord::Migration[5.0]
  def up
    create_table :users do |t|
      t.string :first_name, :limit => 50
      t.string :last_name, :limit => 50
      t.string :email, :limit => 50
      t.boolean :is_admin, :default => false
      t.string :username, :limit => 50, :null => false
      t.string :password_digest, :null => false

      t.timestamps
    end
    add_index("users","username")
  end

  def down
    drop_table :users
  end

end
