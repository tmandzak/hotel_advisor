class HotelsController < ApplicationController
  before_action :signed_in_user, only: [:new, :create]

  def index
    @hotels = Hotel.paginate(page: params[:page])
  end

  def show
  end

  def update
  end

  def new
    @hotel = Hotel.new
    @address = @hotel.build_address
  end

  def create
    @hotel = Hotel.new(hotel_params) 
    @hotel.user = current_user
    @address = @hotel.build_address(address_params)

    if @hotel.save && @address.save
      flash[:success] = "New hotel was added successfully"  
      redirect_to hotels_url
    else
      render 'new'
    end

  end



private

    def hotel_params
      params.require(:hotel).permit(:title, :stars, :breakfast, :description, :price, :photo)
    end
 
    def address_params
      params.require(:address).permit(:country, :city, :state, :street)
    end


end
