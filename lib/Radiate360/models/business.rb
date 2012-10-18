Radiate360::Business = Struct.new :api_username, :api_key, :username, :business_id do
  include StructExtensions

  def pause(toggle)
    Radiate360.call 'businesses/pause', {
      :fields => {:username => self.username, :business_id => self.business_id, :value => value},
      :constraints => { :required => %w(username business_id toggle) },
      :credentials => { :username => :api_username, :password => :api_key }
    }, :post
  end
  
  def bury(toggle)
    Radiate360.call 'businesses/bury', {
      :fields => {:username => self.username, :business_id => self.business_id, :toggle => toggle},
      :constraints => { :required => %w(username business_id toggle) },
      :credentials => { :username => :api_username, :password => :api_key }
    }, :post
  end
end