class HotelsController < ApplicationController
  before_action :signed_in_user, only: [:new, :create, :edit, :update, :destroy, :approval, :approve, :reject]
  before_action :admin_user,     only: [:edit, :update, :destroy, :approval, :approve, :reject]
  
  def index
    @hotels = Hotel.where( approved: true ).paginate(page: params[:page])
  end
  
  def approval
    @hotels = Hotel.where( approved: false ).order(created_at: :desc).paginate(page: params[:page])
  end
  
  def approve
    @hotel = Hotel.find(params[:id])
        
    if @hotel.update_attributes(approved: true)
      flash[:success] = "Hotel is approved"
    end
      
    redirect_to approval_url
  end
  
  def reject
    @hotel = Hotel.find(params[:id])
        
    if @hotel.update_attributes(approved: false)
      flash[:warning] = "Hotel is rejected"
    end
      
    redirect_to rating_url
  end

  def show
    @hotel = Hotel.find(params[:id])
    if current_user && current_user.admin? || @hotel.approved? 
      @rates = @hotel.rates.paginate(page: params[:page])
      @rate = @hotel.rates.build
    else 
      redirect_to rating_url
    end  
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
    session[:return_to] ||= request.referer
  end
  
  def update
    @hotel = Hotel.find(params[:id])
    @address = @hotel.address
    
    if @hotel.update_attributes(hotel_admin_params) && @address.update_attributes(address_params)
      flash[:success] = "Hotel is updated"
      redirect_to session.delete(:return_to)
    else
      render 'edit'
    end
  end

  def destroy
    Hotel.find(params[:id]).destroy
    flash[:danger] = "Hotel is deleted"
    redirect_to request.referer
  end

  private

  def hotel_params
    params.require(:hotel).permit(:title, :stars, :breakfast, :description, :price, :photo)
  end
  
  def hotel_admin_params
    params.require(:hotel).permit(:title, :stars, :breakfast, :description, :price, :photo, :approved)
  end
  
  def address_params
    params.require(:address).permit(:country, :city, :state, :street)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

end
