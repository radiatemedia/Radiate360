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
    stub_request(:get, "https://testuser:testpass@radiate360.com/1/test")

    expect { |b| Radiate360.call('test', {:fields => {:test => 1}}, :get, &b) }.to yield_control
  end

  describe Radiate360::Business do
    before(:each) do
      @business = Radiate360::Business.new(:username => 'tester', :business_id => 1)
    end

    it "should make pause requests" do
      stub_request(:post, "https://testuser:testpass@radiate360.com/1/businesses/1/pause/true")

      expect { |b| @business.pause(true) }.to_not raise_error
    end

    it "should make bury requests" do
      stub_request(:post, "https://testuser:testpass@radiate360.com/1/businesses/1/bury/true")

      expect { |b| @business.bury(true) }.to_not raise_error
    end
  end
end
