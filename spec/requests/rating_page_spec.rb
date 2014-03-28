require 'spec_helper'

describe 'Rating page' do

  subject { page }
  before { visit rating_path }

  it { should have_title('Hotel Advisor | Rating') }
  it { should have_content('Rating') }
  it { should have_link('Add new hotel',    href: new_hotel_path) }

  describe 'for admin' do
    let(:admin) { FactoryGirl.create(:admin) }
    before do
      5.times { FactoryGirl.create(:hotel) }
      sign_in admin
      visit rating_path
    end

    it { should have_link('edit', href: edit_hotel_path(Hotel.first)) }
    it { should have_link('delete', href: hotel_path(Hotel.first)) }

    it "should be able to delete the hotel" do
      expect do
        click_link('delete', match: :first)
      end.to change(Hotel, :count).by(-1)
    end
  end

  describe 'for non admin' do
    let(:user) { FactoryGirl.create(:user) }
    before do
      5.times { FactoryGirl.create(:hotel) }
      sign_in user, no_capybara: true
      visit rating_path
    end

    it { should_not have_link('Delete', href: hotel_path(Hotel.first)) }
    it { should_not have_link('Edit', href: edit_hotel_path(Hotel.first)) }

    describe 'submitting a DELETE request to the Hotels#destroy action' do
      before { delete hotel_path(Hotel.first) }
      specify { expect(response).to redirect_to(root_url) }
    end
  end

  describe 'for not signed in user' do
    before do
      5.times { FactoryGirl.create(:hotel) }
    end

    it { should_not have_link('Delete', href: hotel_path(Hotel.first)) }
    it { should_not have_link('Edit', href: edit_hotel_path(Hotel.first)) }

    describe 'submitting a DELETE request to the Hotels#destroy action' do
      before { delete hotel_path(Hotel.first) }
      specify { expect(response).to redirect_to(signin_path) }
    end
  end

  describe 'without pagination' do

    before(:all) { 20.times { FactoryGirl.create(:hotel) } }
    after(:all)  { Hotel.delete_all }

    it { should_not have_selector('ul.pagination') }

    it 'should list each hotel' do
      Hotel.paginate(page: 1).each do |hotel|
        expect(page).to have_selector('a', text: hotel.title)
      end
    end
  end

  describe 'with pagination' do
    before(:all) { 40.times { FactoryGirl.create(:hotel) } }
    after(:all)  { Hotel.delete_all }

    it { should have_selector('ul.pagination') }
  end
end
