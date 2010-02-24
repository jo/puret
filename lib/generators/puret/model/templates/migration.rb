class Create<%= translations_table_name.camelize %> < ActiveRecord::Migration
  def self.up 
    create_table(:<%= translations_table_name %>) do |t|
      t.references :<%= reference_name %>
      t.string :locale

<% attributes.each do |attribute| -%>
      t.<%= attribute.type %> :<%= attribute.name %>
<% end -%>

      t.timestamps
    end
    add_index :<%= translations_table_name %>, [:<%= reference_id %>, :locale], :unique => true
  end

  def self.down
    drop_table :<%= translations_table_name %>
  end
end

