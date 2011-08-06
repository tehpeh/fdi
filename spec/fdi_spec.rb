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
  let(:valid_attributes) { {
    :time => DateTime.now,
    :temperature => 30.0,
    :drought_factor => 7,
    :wind_speed => 60.0,
    :relative_humidity => 10.0 } }
  let(:obs) { Obs.create(valid_attributes) }

  it 'is valid with valid attributes' do
    obs.should be_valid
  end

  it 'has timestamps' do
    obs.created_at.should be_within(0.1).of(DateTime.now)
    obs.updated_at.should be_within(0.1).of(DateTime.now)
  end

  it 'is not valid without required attributes' do
    Obs.new.should_not be_valid
  end

  it 'does not allow the fdi to be written' do
    expect { obs.fdi = 100 }.to raise_error
  end

  it 'calculates the FDI on save' do
    obs.fdi.should == 12
  end

  describe '.recalculate_fdis' do
    it 'recalculates the fdi for all records' do
      Obs.stub(:all).and_return([obs])
      obs.should_receive :calculate_fdi
      obs.should_receive :save
      Obs.recalculate_fdis
    end
  end
end