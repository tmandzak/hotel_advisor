class RatesController < ApplicationController
  before_action :signed_in_user

  def create
  	@hotel = Hotel.find(rate_params[:hotel_id])
  	@rates = @hotel.rates.paginate(page: params[:page])
    
    @rate = @hotel.rates.build(rate_params) 
    @rate.user = current_user
  	
  	if @rate.save
  	  flash.now[:success] = "Thanks for your rate!"	

  	  @hotel.rates_total += @rate.rate;
  	  @hotel.rate_avg = @hotel.rates_total.to_f / @hotel.rates.count;
  	  @hotel.save

  	  @rate = @hotel.rates.build
  	end

  	render 'hotels/show'
  	
  end

private
	def rate_params
	  params.require(:rate).permit(:rate, :comment, :hotel_id)
	end


end
