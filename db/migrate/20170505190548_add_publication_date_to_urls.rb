class AddPublicationDateToUrls < ActiveRecord::Migration
  def change
    add_column :urls, :publication_date, :date
  end
end
