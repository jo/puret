ActiveRecord::Schema.define(:version => 1) do
  create_table :posts do |t|
    t.timestamps
  end

  create_table :post_translations do |t|
    t.references :post
    t.string :locale
    t.string :title
    t.timestamps
  end
end
