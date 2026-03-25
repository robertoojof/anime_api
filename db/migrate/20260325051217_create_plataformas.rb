class CreatePlataformas < ActiveRecord::Migration[8.1]
  def change
    create_table :plataformas do |t|
      t.string :nome
      t.string :url

      t.timestamps
    end
    add_index :plataformas, :nome, unique: true
  end
end
