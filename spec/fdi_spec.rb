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
  let(:time) { DateTime.now }
  let(:obs) { Obs.new(:time => time) }

  it 'is valid with valid attributes' do
    obs.should be_valid
  end

  it 'stores and retrieves the time' do
    obs.time.should == time
  end
end