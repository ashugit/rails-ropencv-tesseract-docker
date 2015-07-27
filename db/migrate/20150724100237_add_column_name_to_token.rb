class AddColumnNameToToken < ActiveRecord::Migration
  def change
    add_column :tokens, :access_token, :string
  end
end
