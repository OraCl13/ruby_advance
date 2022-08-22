class SearchesController < ApplicationController
  def result
    @general = ThinkingSphinx.search search_params[:request]
  end

  private

  def search_params
    params.require(:user).permit(:request)
  end
end
