require 'spec_helper'

describe 'Add new hotel page: ' do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }

  context 'not signed in user' do
    before { get new_hotel_path }
    specify { expect(response).to redirect_to(signin_path) }
  end

  context 'signed in user' do
    before do
      sign_in user
      visit new_hotel_path
    end

    describe 'form' do
      it{ should have_title 'Hotel Advisor | Add new Hotel' }
      it{ should have_content 'Add new Hotel'}
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

    describe 'creates new hotel' do

      context 'with invalid data' do

        describe 'error message' do
          before do
            click_button 'Save'
          end

          it { should have_selector('div.alert.alert-error') }
        end

        it "should not create a hotel" do
          expect { click_button "Save" }.not_to change(Hotel, :count)
        end

        it "should not create a hotel address" do
          expect { click_button "Save" }.not_to change(Address, :count)
        end

      end

      context 'with valid data' do
        let(:title) { 'Example Hotel' }
        let(:stars) { 5 }
        let(:breakfast) { true }
        let(:photo) { 'hotel_default.jpg'  }
        let(:description) { 'description' }
        let(:price) { 500 }
        let(:country) { 'Ukraine' }
        let(:state) { 'none' }
        let(:city) { 'Lviv' }
        let(:street) { 'Svobody'}


        before do
          fill_in 'Title', with: title
          select stars.to_s, from: 'Stars'
          check 'Breakfast'
          attach_file 'Photo', "#{Rails.root}/app/assets/images/fallback/#{ photo }"
          fill_in 'Description', with: description
          fill_in 'Price', with: price
          fill_in 'Country', with: country
          fill_in 'State', with: state
          fill_in 'City', with: city
          fill_in 'Street', with: street
        end

        it "should create a hotel" do
          expect { click_button "Save" }.to change(Hotel, :count).by(1)
        end

        it "should create a hotel address" do
          expect { click_button "Save" }.to change(Address, :count).by(1)
        end

        describe 'hotel with address is saved correctly' do
          before do
            click_button 'Save'
          end

          let(:hotel) { Hotel.find_by_title(title) }
          let(:address) { Address.find_by_hotel_id(Hotel.find_by_title(title).id)}

          it { should have_selector('div.alert.alert-success') }

          specify { expect(hotel.title).to eq title }
          specify { expect(hotel.stars).to eq stars }
          specify { expect(hotel.breakfast).to eq breakfast }
          specify { expect(hotel.photo.to_s).to eq("/uploads/hotel/photo/#{ hotel.id.to_s }/#{ photo }") }
          specify { expect(hotel.description).to eq description }
          specify { expect(hotel.price).to eq price }
          specify { expect(address.country).to eq country }
          specify { expect(address.state).to eq state }
          specify { expect(address.city).to eq city }
          specify { expect(address.street).to eq street }
        end

      end

    end

  end

end