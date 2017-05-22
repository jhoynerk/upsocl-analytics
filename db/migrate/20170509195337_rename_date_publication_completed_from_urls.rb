class RenameDatePublicationCompletedFromUrls < ActiveRecord::Migration
  def change
    rename_column :urls, :date_publication_completed, :publication_end_date
  end
end
