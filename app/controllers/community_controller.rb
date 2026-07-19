class CommunityController < ApplicationController
  def index
    # Community & Sharing isn't built yet — hide it for now rather than
    # show the unbuilt placeholder page. Route/controller stay in place
    # for whoever picks up that feature.
    redirect_to root_path
  end
end
