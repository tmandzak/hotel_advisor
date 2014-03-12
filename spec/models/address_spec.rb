require 'spec_helper'

describe Address do
  before do
    @address = Address.new
  end

  subject { @address }

  it { should respond_to(:country) }
  it { should respond_to(:state) }
  it { should respond_to(:city) }
  it { should respond_to(:street) }
    
  it { should be_valid }

  
end
