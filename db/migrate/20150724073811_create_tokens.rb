class CreateTokens < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.string :new

      t.timestamps null: false
    end
  end
end
