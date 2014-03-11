require 'spec_helper'

describe Rate do

  before do
  	@user = User.new(id: 1, name: "Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar") 
  	@hotel = Hotel.new(id: 1, title: "Grand Hotel", stars: 5, breakfast: true, description: "Nice room", price: 500.00)
	@rate = Rate.new(rate: 5, comment: "text")
	@rate.user = @user
	@rate.hotel = @hotel
  end

  subject { @rate }

  it { should respond_to(:rate) }
  it { should respond_to(:comment) }
  it { should respond_to(:user) }
  it { should respond_to(:hotel) }

  its(:user) { should eq @user }
  its(:hotel) { should eq @hotel }
  
  it { should be_valid }

  describe "when rate is not present" do
    before { @rate.rate = nil }
    it { should_not be_valid }
  end

  describe "when rate comment is not present" do
    before { @rate.comment = " " }
    it { should_not be_valid }
  end
 
end
