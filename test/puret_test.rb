require 'test_helper'

class PuretTest < ActiveSupport::TestCase
  def setup
    setup_db
    I18n.locale = I18n.default_locale = :en
    Post.create(:title => 'English title')
  end

  def teardown
    teardown_db
  end

  test "database setup" do
    assert Post.count == 1
  end
 
  test "allow translation" do
    I18n.locale = :de
    Post.first.update_attribute :title, 'Deutscher Titel'
    assert_equal 'Deutscher Titel', Post.first.title
    I18n.locale = :en
    assert_equal 'English title', Post.first.title
  end
 
  test "assert fallback to default" do
    assert Post.first.title == 'English title'
    I18n.locale = :de
    assert Post.first.title == 'English title'
  end
 
  test "post has_many translations" do
    assert_equal PostTranslation, Post.first.translations.first.class
  end
 
  test "translations are deleted when parent is destroyed" do
    I18n.locale = :de
    Post.first.update_attribute :title, 'Deutscher Titel'
    assert_equal 2, PostTranslation.count
    
    Post.destroy_all
    assert_equal 0, PostTranslation.count
  end
  
  test 'validates_presence_of should work' do
    post = Post.new
    assert_equal false, post.valid?
    
    post.title = 'English title'
    assert_equal true, post.valid?
  end

  test 'temporary locale switch should not clear changes' do
    I18n.locale = :de
    post = Post.first
    post.text = 'Deutscher Text'
    post.title.blank?
    assert_equal 'Deutscher Text', post.text
  end
end
