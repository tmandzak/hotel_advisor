require 'spec_helper'

describe Hotel do

  before do
  	@user = User.new(id: 1, name: "Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar") 
  	@hotel = Hotel.new(title: "Grand Hotel", stars: 5, breakfast: true, description: "Nice room", price: 500.00)
	@hotel.user = @user
	@address = @hotel.build_address(country: "Ukraine", city: "L'viv", street: "Svobody, 10")
  end

  subject { @hotel }

  it { should respond_to(:title) }
  it { should respond_to(:stars) }
  it { should respond_to(:breakfast) }
  it { should respond_to(:description) }
  it { should respond_to(:price) }
  it { should respond_to(:photo) }
  it { should respond_to(:address) }
  it { should respond_to(:rates_count) }
  it { should respond_to(:rates_total) }
  it { should respond_to(:rate_avg) }
  it { should respond_to(:user) }
  its(:user) { should eq @user }
  its(:address) { should eq @address }
  
  it { should be_valid }

  describe "when hotel title is not present" do
    before { @hotel.title = " " }
    it { should_not be_valid }
  end

  describe "when hotel title is too long" do
    before { @hotel.title = "a" * 51 }
    it { should_not be_valid }
  end

  describe "when hotel title is already taken" do
    before do
      hotel_with_same_title = @hotel.dup
      hotel_with_same_title.save
    end

    it { should_not be_valid }
  end

  describe "when star rating is not present" do
    before { @hotel.stars = nil }
    it { should_not be_valid }
  end

  describe "when rates fields are not assigned" do
    its(:rates_count) { should eq 0 }
    its(:rates_total) { should eq 0 }
    its(:rate_avg) { should eq 0.0 }
  end

  describe "rates associations" do
     
     before { @hotel.save }
     
     let!(:rate1) do
       @hotel.rates.build(rate: 5, comment: "text", created_at: 1.hour.ago)
     end
     let!(:rate2) do
       @hotel.rates.build(rate: 4, comment: "text", created_at: 1.hour.ago)
     end
     let!(:rate3) do
       @hotel.rates.build(rate: 5, comment: "text", created_at: 1.day.ago)
     end
     let!(:rate4) do
       @hotel.rates.build(rate: 4, comment: "text", created_at: 1.day.ago)
     end

     it "should have the right rates in the right order" do
       expect(@hotel.rates.to_a).to eq [rate1, rate2, rate3, rate4]
     end

  end 
  
end