class FacebookPostsDecorator < Draper::CollectionDecorator
	delegate :total_pages, :current_page, :first_page?, :last_page?, :count
end