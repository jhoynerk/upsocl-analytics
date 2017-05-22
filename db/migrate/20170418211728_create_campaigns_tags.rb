class CreateCampaignsTags < ActiveRecord::Migration
  def change
    create_table :campaigns_tags do |t|
      t.belongs_to :campaign, index: true
      t.belongs_to :tag, index: true
    end
  end
end
