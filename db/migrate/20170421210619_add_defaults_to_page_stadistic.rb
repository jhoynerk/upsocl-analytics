class AddDefaultsToPageStadistic < ActiveRecord::Migration
  def change
    change_column_default :page_stadistics, :avgtimeonpage, 0
    change_column_default :page_stadistics, :pageviews, 0
    change_column_default :page_stadistics, :sessions, 0
    change_column_default :page_stadistics, :users, 0
  end
end
