require 'spec_helper'

describe 'Rating page' do

  subject { page }

  describe 'for all' do
    before { visit rating_path }

    it { should have_title('Hotel Advisor | Rating') }
    it { should have_content('Rating') }
    it { should have_link('Add new hotel',    href: new_hotel_path) }
  end

  describe 'for admin' do
    let(:admin) { FactoryGirl.create(:admin) }
    before do
      5.times { FactoryGirl.create(:hotel) }
      sign_in admin
      visit rating_path
    end
    after(:all) do
      Hotel.delete_all
      User.delete_all
    end

    it { should have_link('reject', href: '/reject/'+Hotel.first.id.to_s) }
    it { should have_link('edit', href: edit_hotel_path(Hotel.first)) }
    it { should have_link('delete', href: hotel_path(Hotel.first)) }

    it "should be able to reject the hotel" do
      hotel = Hotel.first

      click_link('reject', href: '/reject/'+hotel.id.to_s)
      expect(hotel.reload.approved).to eq false
    end

    it "should be able to edit the hotel" do
      click_link('edit', match: :first)
      expect(page).to have_content 'Edit Hotel'

      click_button('Save')
      expect(page).to have_content 'Rating'
    end

    it "should be able to delete the hotel" do
      expect { click_link('delete', match: :first) }.to change(Hotel, :count).by(-1)
      expect(page).to have_content 'Rating'
    end
  end

  describe 'for non admin user' do
    let(:user) { FactoryGirl.create(:user) }
    before do
      5.times { FactoryGirl.create(:hotel) }
      sign_in user, no_capybara: true
      visit rating_path
    end
    after(:all) do
      Hotel.delete_all
      User.delete_all
    end

    it { should_not have_link('reject') }
    it { should_not have_link('edit') }
    it { should_not have_link('delete') }

    describe 'submitting a GET request to the Hotels#reject action' do
      before { get '/reject/'+Hotel.first.id.to_s }
      specify { expect(response).to redirect_to(root_url) }
    end

    describe 'submitting a GET request to the Hotels#edit action' do
      before { get edit_hotel_path(Hotel.first) }
      specify { expect(response).to redirect_to(root_url) }
    end

    describe 'submitting a DELETE request to the Hotels#destroy action' do
      before { delete hotel_path(Hotel.first) }
      specify { expect(response).to redirect_to(root_url) }
    end
  end

  describe 'for not signed in user' do
    before { 5.times { FactoryGirl.create(:hotel) } }
    after(:all) { Hotel.delete_all }

    it { should_not have_link('reject') }
    it { should_not have_link('edit') }
    it { should_not have_link('delete') }

    describe 'submitting a GET request to the Hotels#reject action' do
      before { get '/reject/'+Hotel.first.id.to_s }
      specify { expect(response).to redirect_to(signin_url) }
    end

    describe 'submitting a GET request to the Hotels#edit action' do
      before { get edit_hotel_path(Hotel.first) }
      specify { expect(response).to redirect_to(signin_url) }
    end

    describe 'submitting a DELETE request to the Hotels#destroy action' do
      before { delete hotel_path(Hotel.first) }
      specify { expect(response).to redirect_to(signin_url) }
    end
  end

  describe 'without pagination' do
    before do
      20.times { FactoryGirl.create(:hotel) }
      visit rating_path
    end
    after(:all)  { Hotel.delete_all }

    it { should_not have_selector('ul.pagination.pagination') }

    it 'should list each hotel' do
      Hotel.paginate(page: 1).each do |hotel|
        expect(page).to have_selector('a', text: hotel.title)
      end
    end
  end

  describe 'with pagination' do
    before do
      40.times { FactoryGirl.create(:hotel) }
      visit rating_path
    end
    after(:all)  { Hotel.delete_all }

    it { should have_selector('ul.pagination.pagination') }
  end

  describe 'show only approved hotels' do
    let(:hotel_not_approved) { FactoryGirl.create(:hotel, approved: false, rate_avg: 5)}

    before do
      5.times { FactoryGirl.create(:hotel)}
      visit rating_path
    end
    after(:all)  { Hotel.delete_all }

    it { should_not have_selector("a##{hotel_not_approved.id}") }

    it "should show all approved hotels" do
      Hotel.where(approved: true).each do |hotel|

        expect(page).to have_selector("a##{hotel.id}")

        within("a##{hotel.id}") do
          expect(page).to have_css("img[src='#{hotel.photo}']")
          expect(page).to have_selector('h4', text: hotel.title+'*'*hotel.stars)
          expect(page).to have_selector('h4', text: "Average of 2 rates: #{ '%.1f' % hotel.rate_avg } / 5")
        end

      end

    end

  end

end
