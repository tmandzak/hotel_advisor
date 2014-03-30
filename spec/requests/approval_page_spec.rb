require 'spec_helper'

describe 'Approval page' do

  subject { page }

  describe 'for admin' do
    let(:admin) { FactoryGirl.create(:admin) }
    before do
      5.times { FactoryGirl.create(:hotel_not_approved) }
      sign_in admin
      visit approval_path
    end
    after(:all) do
      Hotel.delete_all
      User.delete_all
    end

    it { should have_title('Hotel Advisor | Approval') }
    it { should have_content('Approval') }
    it { should have_link('Approval', href: approval_path) }
    it { should have_link('approve', href: '/approve/'+Hotel.first.id.to_s) }
    it { should have_link('edit', href: edit_hotel_path(Hotel.first)) }
    it { should have_link('delete', href: hotel_path(Hotel.first)) }

    it "should be able to approve the hotel" do
      hotel = Hotel.first

      click_link('approve', href: '/approve/'+hotel.id.to_s)
      expect(hotel.reload.approved).to eq true
    end

    it "should be able to edit the hotel" do
      click_link('edit', match: :first)
      expect(page).to have_content 'Edit Hotel'

      click_button('Save')
      expect(page).to have_content 'Approval'
    end

    it "should be able to delete the hotel" do
      expect { click_link('delete', match: :first) }.to change(Hotel, :count).by(-1)
      expect(page).to have_content 'Approval'
    end
  end

  describe 'for non admin user' do
    let(:user) { FactoryGirl.create(:user) }
    before do
      5.times { FactoryGirl.create(:hotel_not_approved) }
      sign_in user, no_capybara: true
      visit approval_path
    end
    after(:all) do
      Hotel.delete_all
      User.delete_all
    end
    
    it { should_not have_link('Approval', href: approval_path) }

    describe 'submitting a GET request to the Hotels#approve action' do
      before { get '/approve/'+Hotel.first.id.to_s }
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
    before { 5.times { FactoryGirl.create(:hotel_not_approved) } }
    after(:all) { Hotel.delete_all }

    describe 'submitting a GET request to the Hotels#approve action' do
      before { get '/approve/'+Hotel.first.id.to_s }
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
    let(:admin) { FactoryGirl.create(:admin) }
    before do
      20.times { FactoryGirl.create(:hotel_not_approved) }
      sign_in admin
      visit approval_path
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
    let(:admin) { FactoryGirl.create(:admin) }
    before do
      40.times { FactoryGirl.create(:hotel_not_approved) }
      sign_in admin
      visit approval_path
    end
    after(:all)  { Hotel.delete_all }

    it { should have_selector('ul.pagination.pagination') }
  end

  describe 'shows only not approved hotels' do
    let(:admin) { FactoryGirl.create(:admin) }
    let(:hotel_approved) { FactoryGirl.create(:hotel, rate_avg: 5)}
    
    before do
      5.times { FactoryGirl.create(:hotel_not_approved)}
      sign_in admin
      visit approval_path
    end
    after(:all)  { Hotel.delete_all }

    it { should_not have_selector("a##{ hotel_approved.id }") }

    it "should show all not approved hotels" do
      Hotel.where(approved: false).each do |hotel|

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
