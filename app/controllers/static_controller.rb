class StaticController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    render file: Rails.public_path.join("index.html"), status: :ok
  end
end
