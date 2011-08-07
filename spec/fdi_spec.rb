require 'spec_helper'

#curl -w "\ncontent-type: %{content_type}\nhttp-code: %{http_code}\n" -H "HTTP_ACCEPT: application/json" localhost:4567/

describe 'fdi' do
  let(:accept_json) { {'HTTP_ACCEPT' => 'application/json'} }

  describe 'GET /' do
    it 'responds ok' do
      get '/'
      last_response.should be_ok
    end
  end

  context 'Obs API' do
    let(:obs) { double('Obs', :id => 1).as_null_object }

    describe 'GET /obs' do
      it 'returns all Obs as JSON' do
        Obs.should_receive(:all).and_return([obs])
        get '/obs', nil, accept_json
        last_response.body.should == [obs].to_json
      end
    end

    describe 'GET /obs/1' do
      it 'returns the Obs as JSON' do
        Obs.should_receive(:get).with("1").and_return(obs)
        get '/obs/1', nil, accept_json
        last_response.body.should == obs.to_json
      end
    end

    describe 'POST /obs' do
      it 'creates a new Obs' do
        params = { :obs => {
          "time" => DateTime.now.to_s,
          "temperature" => "30.0",
          "drought_factor" => "7",
          "wind_speed" => "60.0",
          "relative_humidity" => "10.0"} }

        Obs.should_receive(:new).with(params[:obs]).and_return(obs)
        post '/obs', params, accept_json
        last_response.body.should == obs.to_json
        last_response.status.should == 201
        last_response.headers['location'].should == "/obs/1"
      end
    end
  end
end

describe Obs do
  let(:valid_attributes) { {
    :time => Time.now,
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