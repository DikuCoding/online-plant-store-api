class CreateMessages < ActiveRecord::Migration[7.2]
  def change
    create_table :messages do |t|
      t.references :user, null: false, foreign_key: true
      t.text :content
      t.boolean :read_status

      t.timestamps
    end
  end
end
