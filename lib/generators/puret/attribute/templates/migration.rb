class Add<%= translations_table_name.camelize %> < ActiveRecord::Migration
  def self.up 
    change_table(:<%= translations_table_name %>) do |t|
<% attributes.each do |attribute| -%>
      t.<%= attribute.type %> :<%= attribute.name %>
<% end -%>
    end
  end

  def self.down
    change_table(:<%= translations_table_name %>) do |t|
<% attributes.each do |attribute| -%>
      t.remove :<%= attribute.name %>
<% end -%>
    end
  end
end

