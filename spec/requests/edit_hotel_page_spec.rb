require 'spec_helper'

describe 'Edit hotel page: ' do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:admin) }
  let!(:address) { FactoryGirl.create(:address) }
  let(:hotel) { FactoryGirl.create(:hotel, address: address) }
  

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
  
  # context 'signed in admin user' do
    # before do
      # sign_in admin, no_capybara: true
      # visit edit_hotel_path(hotel.id)
    # end
# 
    # describe 'form' do
      # it{ should have_title 'Hotel Advisor | Edit Hotel' }
      # it{ should have_content 'Edit Hotel'}
      # it{ should have_field 'Title'}
      # it{ should have_field 'Stars'}
      # it{ should have_field 'Breakfast'}
      # it{ should have_field 'Description'}
      # it{ should have_field 'Price'}
      # it{ should have_field 'Photo'}
      # it{ should have_field 'Country'}
      # it{ should have_field 'City'}
      # it{ should have_field 'State'}
      # it{ should have_field 'Street'}
      # it{ should have_field 'Street'}
      # it{ should have_button 'Save'}
    # end
# 
#     
  # end

end

