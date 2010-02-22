require 'rubygems'
require 'test/unit'
require 'active_support'
require "active_record"
require 'puret'

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

def setup_db
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
end
 
def teardown_db
  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.drop_table(table)
  end
end

class Post < ActiveRecord::Base
  puret :title, :text
  validates_presence_of :title
end

class PostTranslation < ActiveRecord::Base
  puret_for :post
end
