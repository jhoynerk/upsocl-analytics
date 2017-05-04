class SearchUrls
  def initialize(url_id = nil)
    @url_id = url_id
  end

  def searh
    search_urls
  end

  private
    def search_urls
      (@url_id.nil?) ? search_all_urls : search_url
    end

    def search_url
      Url.where(id: @url_id)
    end

    def search_all_urls
      Url.search_urls_to_update
    end
end
