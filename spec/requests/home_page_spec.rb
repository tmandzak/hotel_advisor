require 'spec_helper'

describe 'Home page' do

  subject { page }
  before { visit root_path }

  it { should have_title("Hotel Advisor") }
  it { should have_content("Top 5") }

  it "should show top 5 hotels" do
    Hotel.take(5).each do |hotel|
      expect(page).to have_selector("a##{hotel.id}")

      within("a##{hotel.id}") do
        expect(page).to have_css("img[src='#{hotel.photo}']")
        expect(page).to have_selector('h4', text: hotel.title+'*'*hotel.stars)
        expect(page).to have_selector('p', text: "Average of #{ pluralize(hotel.rates_count, "rate") }: #{ '%.1f' % hotel.rate_avg } / 5")
      end
    end
  end
end