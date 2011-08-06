require 'spec_helper'

describe 'fdi' do
  describe 'GET /' do
    it 'responds ok' do
      get '/'
      last_response.should be_ok
    end
  end
end

describe Obs do
  let(:valid_attributes) { { :time => DateTime.now } }
  let(:obs) { Obs.create(valid_attributes) }

  it 'is valid with valid attributes' do
    obs.should be_valid
  end

  it 'has attribute created_at' do
    obs.created_at.should be_within(0.1).of(DateTime.now)
  end

  it 'has attribute updated_at' do
    obs.updated_at.should be_within(0.1).of(DateTime.now)
  end

  it 'has attribute time' do
    obs.time.should == valid_attributes[:time]
  end

  it 'is not valid without required attributes' do
    Obs.new.should_not be_valid
  end
end