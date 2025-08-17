class AddInviteCodeToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :invite_code, :string
  end
end
