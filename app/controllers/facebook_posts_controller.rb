class FacebookPostsController < ApplicationController
  layout false
  def show
    @url = FacebookPost.find(params[:id]).decorate
    respond_to do |format|
      format.html {}
      format.json { render :json => @url.as_json( methods: [ :tags, :tag_names, :campaign, :social_count, :stadistics, :totals_stadistics, :next_url, :previous_url, :count_votes ]) }
    end
  end

  def show_view
    render :show
  end

end
