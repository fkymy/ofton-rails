class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.belongs_to :entry, index: true, null: false
      t.text :body, null: false

      t.timestamps
    end
  end
end