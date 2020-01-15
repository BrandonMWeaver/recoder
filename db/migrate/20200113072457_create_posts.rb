class CreatePosts < ActiveRecord::Migration[6.0]

  def change
    create_table :posts do |t|
      t.text :code_snippet
      t.text :description
      t.integer :user_id
    end
  end

end
