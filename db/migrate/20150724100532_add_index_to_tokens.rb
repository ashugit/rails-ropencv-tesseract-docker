class AddIndexToTokens < ActiveRecord::Migration
  def change
    add_column :tokens, :token, :string
    add_index :tokens, :token
  end
end
