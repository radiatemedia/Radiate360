require 'spec_helper'

describe Radiate360 do
  before(:all) do
    @log = StringIO.new

    logger = Logger.new(@log)

    Radiate360.configure do |config|
      config.username = 'testuser'
      config.password = 'testpass'
      config.base_url = 'http://radiate360.com'
      config.ssl      = true
      config.logger   = logger
    end
  end

  it "should make requests" do
    stub_request(:get, "https://testuser:testpass@radiate360.com/1/businesses/1/campaigns/1/pause")

    expect { |b| Radiate360.call('businesses/1/campaigns/1/pause', {:fields => {:test => 1}}, :get, &b) }.to yield_control
  end
end
