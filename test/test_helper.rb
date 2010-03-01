require 'rubygems'
require 'test/unit'
require 'active_support'
require "active_record"
require 'puret'
require 'logger'

ActiveRecord::Base.logger = Logger.new(nil)
ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

def setup_db
  ActiveRecord::Migration.verbose = false
  load "schema.rb"
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
