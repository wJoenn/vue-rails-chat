class StaticController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    render file: "public/index.html", status: :ok
  end
end
