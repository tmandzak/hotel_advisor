require 'spec_helper'

describe "Pages" do

  subject { page }

  describe "Home page" do

    before { visit root_path }

    it { should have_title("Hotel Advisory") } 
    it { should have_content('Top 5') }
  end

  describe "Rating page" do

    before { visit rating_path }

    it { should have_title("Hotel Advisory | Rating") } 
    it { should have_content('Rating') }
  end
end