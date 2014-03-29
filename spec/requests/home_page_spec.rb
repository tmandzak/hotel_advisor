require 'spec_helper'

# include ActionView::Helpers::TextHelper

describe 'Home page' do

  subject { page }

  let(:hotel_not_approved) { FactoryGirl.create(:hotel, approved: false, rate_avg: 5)}
  let(:hotel_out_of_top5) { FactoryGirl.create(:hotel, rate_avg: 1)}

  before do
    5.times { FactoryGirl.create(:hotel)}
    visit root_path
  end

  it { should have_title("Hotel Advisor") }
  it { should have_content("Top 5") }
  it { should_not have_selector("a##{hotel_not_approved.id}") }
  it { should_not have_selector("a##{hotel_out_of_top5.id}") }

  it "should show top 5 approved hotels" do
    Hotel.where(approved: true).take(5).each do |hotel|

      expect(page).to have_selector("a##{hotel.id}")

      within("a##{hotel.id}") do
        expect(page).to have_css("img[src='#{hotel.photo}']")
        expect(page).to have_selector('h4', text: hotel.title+'*'*hotel.stars)
        expect(page).to have_selector('h4', text: "Average of 2 rates: #{ '%.1f' % hotel.rate_avg } / 5")
      end

    end

  end

end