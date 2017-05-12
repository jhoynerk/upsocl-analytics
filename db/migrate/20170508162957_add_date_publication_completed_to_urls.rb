class AddDatePublicationCompletedToUrls < ActiveRecord::Migration
  def change
    add_column :urls, :date_publication_completed, :date
  end
end
