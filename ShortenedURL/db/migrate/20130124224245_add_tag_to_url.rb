class AddTagToUrl < ActiveRecord::Migration
  def change
    add_column :urls, :tag, :text
  end
end
