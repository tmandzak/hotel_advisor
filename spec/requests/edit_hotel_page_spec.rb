require 'spec_helper'

describe 'Edit hotel page: ' do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:admin) }
  let!(:address) { FactoryGirl.create(:address) }
  let(:hotel) { FactoryGirl.create(:hotel, address: address) }
  
  after(:all) do
    Hotel.delete_all
    Address.delete_all
    User.delete_all
  end
  

  context 'not signed in user' do
    before { get edit_hotel_path(hotel) }
    specify { expect(response).to redirect_to(signin_path) }
    
    describe 'trying to patch' do
      before { patch hotel_path(hotel) }
      specify { expect(response).to redirect_to(signin_path) }
    end    
  end
  
  context 'non admin user' do
    before do
      sign_in user, no_capybara: true
      get edit_hotel_path(hotel)
    end  
    specify { expect(response).to redirect_to(root_path) }
    
    describe 'trying to patch' do
      before { patch hotel_path(hotel) }
      specify { expect(response).to redirect_to(root_path) }
    end   
  end
  
  context 'signed in admin user' do
    before do
      sign_in admin
      visit edit_hotel_path(hotel)
    end

    describe 'form' do
      it{ should have_title 'Hotel Advisor | Edit Hotel' }
      it{ should have_content 'Edit Hotel'}
      it{ should have_field 'Title'}
      it{ should have_field 'Stars'}
      it{ should have_field 'Breakfast'}
      it{ should have_field 'Description'}
      it{ should have_field 'Price'}
      it{ should have_field 'Photo'}
      it{ should have_field 'Country'}
      it{ should have_field 'City'}
      it{ should have_field 'State'}
      it{ should have_field 'Street'}
      it{ should have_field 'Street'}
      it{ should have_button 'Save'}
    end

    describe 'updating a hotel' do

      context 'with invalid data' do
        before do
          fill_in 'Title', with: ''
          click_button 'Save' 
        end
 
        it { should have_selector('div.alert.alert-danger') }
      end

      context 'with valid data' do
        let(:title) { 'new' }
        let(:stars) { 6 }
        let(:description) { 'new' }
        let(:photo) { 'hotel_update.jpg'  }
        let(:price) { hotel.price+1 }
        let(:country) { 'Germany' }
        let(:state) { 'new' }
        let(:city) { 'new' }
        let(:street) { 'new' }
        
        before do
          fill_in 'Title', with: title
          select stars.to_s, from: 'Stars'
          uncheck 'Breakfast'
          attach_file 'Photo', "#{Rails.root}/app/assets/images/fallback/#{ photo }"
          fill_in 'Description', with: description
          fill_in 'Price', with: price
          select country, from: 'Country'
          fill_in 'State', with: state
          fill_in 'City', with: city
          fill_in 'Street', with: street
          
          click_button 'Save'
          redirect_to rating_url
          
          hotel.reload
          address.reload 
        end
        
        it { should have_selector('div.alert.alert-success') }
        
        specify { expect(hotel.title).to eq title }
        specify { expect(hotel.stars).to eq stars }
        specify { expect(hotel.breakfast).to eq false }
        specify { expect(hotel.description).to eq description }
        specify { expect(hotel.price).to eq price }
        specify { expect(hotel.photo.to_s).to eq("/uploads/hotel/photo/#{ hotel.id.to_s }/#{ photo }") }
        specify { expect(address.country).to eq country }
        specify { expect(address.state).to eq state }
        specify { expect(address.city).to eq city }
        specify { expect(address.street).to eq street }
      end
    end
end

    
end



