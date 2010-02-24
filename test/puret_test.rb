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
    assert_equal 1, Post.count
  end
 
  test "allow translation" do
    I18n.locale = :de
    Post.first.update_attribute :title, 'Deutscher Titel'
    assert_equal 'Deutscher Titel', Post.first.title
    I18n.locale = :en
    assert_equal 'English title', Post.first.title
  end
 
  test "assert fallback to default locale" do
    post = Post.first
    I18n.locale = :sv
    post.title = 'Svensk titel'
    I18n.locale = :en
    assert_equal 'English title', post.title
    I18n.locale = :de
    assert_equal 'English title', post.title
  end
 
  test "assert fallback to saved default locale defined on instance" do
    post = Post.first
    def post.default_locale() :sv; end
    assert_equal :sv, post.puret_default_locale
    I18n.locale = :sv
    post.title = 'Svensk titel'
    post.save!
    I18n.locale = :en
    assert_equal 'English title', post.title
    I18n.locale = :de
    assert_equal 'Svensk titel', post.title
  end
 
  test "assert fallback to saved default locale defined on class level" do
    post = Post.first
    def Post.default_locale() :sv; end
    assert_equal :sv, post.puret_default_locale
    I18n.locale = :sv
    post.title = 'Svensk titel'
    post.save!
    I18n.locale = :en
    assert_equal 'English title', post.title
    I18n.locale = :de
    assert_equal 'Svensk titel', post.title
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
    assert !post.title.blank?
    assert_equal 'Deutscher Text', post.text
  end

  test 'temporary locale switch should work like expected' do
    post = Post.new
    post.title = 'English title'
    I18n.locale = :de
    post.title = 'Deutscher Titel'
    post.save
    assert_equal 'Deutscher Titel', post.title
    I18n.locale = :en
    assert_equal 'English title', post.title
  end

  test 'translation model should validate presence of model' do
    t = PostTranslation.new
    t.valid?
    assert_not_nil t.errors[:post]
  end

  test 'translation model should validate presence of locale' do
    t = PostTranslation.new
    t.valid?
    assert_not_nil t.errors[:locale]
  end

  test 'translation model should validate uniqueness of locale in model scope' do
    post = Post.first
    t1 = PostTranslation.new :post => post, :locale => "de"
    t1.save!
    t2 = PostTranslation.new :post => post, :locale => "de"
    assert_not_nil t2.errors[:locale]
  end
end
