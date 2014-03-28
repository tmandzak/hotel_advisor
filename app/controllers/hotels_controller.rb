class HotelsController < ApplicationController
  before_action :signed_in_user, only: [:new, :create, :edit, :update, :destroy]
  before_action :admin_user,     only: [:edit, :update, :destroy]
  
  def index
    @hotels = Hotel.paginate(page: params[:page])
  end

  def show
    @hotel = Hotel.find(params[:id])
    @rates = @hotel.rates.paginate(page: params[:page])
    @rate = @hotel.rates.build
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
      redirect_to hotel_url(@hotel.id)
    else
      render 'new'
    end
  end
  
  def edit
    @hotel = Hotel.find(params[:id])
    @address = @hotel.address
  end
  
  def update
    @hotel = Hotel.find(params[:id])
    @address = @hotel.address
    
    if @hotel.update_attributes(hotel_params) && @address.update_attributes(address_params)
      flash[:success] = "Hotel is updated"
      redirect_to rating_url
    else
      render 'edit'
    end
  end

  def destroy
    Hotel.find(params[:id]).destroy
    flash[:success] = "Hotel is deleted"
    redirect_to rating_url
  end

  private

  def hotel_params
    params.require(:hotel).permit(:title, :stars, :breakfast, :description, :price, :photo)
  end
  
  def address_params
    params.require(:address).permit(:country, :city, :state, :street)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

end
