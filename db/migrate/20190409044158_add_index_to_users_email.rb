class AddIndexToUsersEmail < ActiveRecord::Migration[5.1]
  def change
    add_index :users, :email, unique: true
    # インデックス追加・・・・・・一意性を強制
  end
end
