class SearchesController < ApplicationController
  def result
    @general = []
    return @general = ThinkingSphinx.search unless additional_params

    return @general = ThinkingSphinx.search(search_params) unless additional_params.values.include? '1'

    additional_params.each do |key, value|
      obj = Object.const_get(key)
      obj.connection
      @general += obj.search(search_params).to_a if value == '1'
    end
    @general
  end

  private

  def search_params
    params[:user][:request]
  end

  def additional_params
    params[:user]&.except(:request)
  end
end
