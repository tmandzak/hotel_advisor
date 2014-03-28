class PagesController < ApplicationController
  def home
  	@hotels = Hotel.where( approved: true ).take(5)
  end
end
