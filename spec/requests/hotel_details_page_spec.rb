require 'spec_helper'
require 'action_view'
require 'action_view/helpers'
include ActionView::Helpers::DateHelper

describe 'Hotel details page' do

  subject { page }

  let(:hotel) { FactoryGirl.create(:hotel) }
  let(:address) { FactoryGirl.create(:address) }
  let(:user) { FactoryGirl.create(:user) }

  before { hotel.address = address }

  describe 'show hotel details' do
    before { visit hotel_path(hotel.id) }

    it { should have_title('Hotel Advisor | Hotel details') }
    it { should have_content(hotel.title+'*'*hotel.stars) }
    it { should have_content(hotel.rate_avg) }
    it { should have_content(hotel.stars) }
    it { should have_content(hotel.description) }
    it { should have_content(hotel.price) }
    it { should have_content(hotel.breakfast ? 'yes':'no') }
    it { should have_css("img[src='#{hotel.photo}']") }
    it { should have_content(hotel.address.country) }
    it { should have_content(hotel.address.state) }
    it { should have_content(hotel.address.city) }
    it { should have_content(hotel.address.street) }
  end

  context 'hotel rates are available' do
    before do
      FactoryGirl.create(:rate, hotel: hotel, user: user)
      FactoryGirl.create(:rate, hotel: hotel, user: user)
      visit hotel_path(hotel.id)
    end

    it "should show hotel rates" do
      hotel.rates.each do |rate|
        expect(page).to have_selector("div##{rate.id}")

        within("div##{rate.id}") do
          expect(page).to have_content(user.name)
          expect(page).to have_content("Rate: #{rate.rate} / 5")
          expect(page).to have_content(rate.comment)
          expect(page).to have_content("Rated #{ time_ago_in_words(rate.created_at) } ago")
        end
      end
    end
  end

  context 'hotel rates are not available' do
    before { visit hotel_path(hotel.id) }

    it "should show No rates message" do
      expect(page).to have_content("No rates")
    end
  end

  context 'for not signed in user' do
    before { visit hotel_path(hotel.id) }

    it { should have_link("Please sign in to rate", href: signin_path) }
  end

  context 'for signed in user' do
    before do
      sign_in user
      visit hotel_path(hotel.id)
    end

    it { should_not have_link("Please sign in to rate", href: signin_path) }

    describe 'show hotel rate form' do
      it { should have_field('Rate') }
      it { should have_field('Leave your comment...') }
      it { should have_button('Rate') }
    end

    describe 'rating the hotel' do
      let(:new_rate) { 3 }
      let(:new_comment) { 'comment' }
      before do
        select new_rate.to_s, from: 'Rate'
        fill_in 'Leave your comment...', with: new_comment
        hidden_field = find("input[id='rate_hotel_id']")
        hidden_field.set hotel.id.to_s
      end

      it "should create a rate" do
        expect { click_button "Rate" }.to change(Rate, :count).by(1)
      end

      describe 'correct saving' do
        before do
          click_button 'Rate'
        end
        let(:rate) { Rate.order(:id).first }

        it { should have_selector('div.alert.alert-success') }
        it { should have_selector("div##{rate.id}") }

        specify { expect(rate.rate).to eq new_rate }
        specify { expect(rate.comment).to eq new_comment }
      end
    end

  end

end

