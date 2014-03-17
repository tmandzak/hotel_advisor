require 'spec_helper'

describe 'Pages' do

  subject { page }

  describe 'Home page' do

    before { visit root_path }

    it { should have_title('Hotel Advisor') }
    it { should have_content('Top 5') }
  end

  describe 'Rating page' do

    before { visit rating_path }

    it { should have_title('Hotel Advisor | Rating') }
    it { should have_content('Rating') }
    it { should have_link('Add new hotel',    href: new_hotel_path) }

    describe 'without pagination' do

      before(:all) { 20.times { FactoryGirl.create(:hotel) } }
      after(:all)  { Hotel.delete_all }

      it { should_not have_selector('div.pagination') }

      it 'should list each hotel' do
        Hotel.paginate(page: 1).each do |hotel|
          expect(page).to have_selector('li', text: hotel.title)
        end
      end
    end 

    describe 'with pagination' do
      before(:all) { 40.times { FactoryGirl.create(:hotel) } }
      after(:all)  { Hotel.delete_all }

      it { should have_selector('div.pagination') }
    end 
  end




  describe 'Hotel details' do

    before { visit root_path }

    it { should have_title('Hotel Advisor') }
    it { should have_content('Top 5') }
  end


end