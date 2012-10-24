Radiate360::Business = Struct.new :api_username, :api_key, :username, :business_id do
  include StructExtensions

  def pause(toggle)
    Radiate360.call 'businesses/pause', {
      :fields => {:username => self.username, :business_id => self.business_id, :pause => toggle},
      :constraints => { :required => %w(username business_id pause) },
      :credentials => { :username => :api_username, :password => :api_key }
    }, :post
  end
  
  def bury(toggle)
    Radiate360.call 'businesses/bury', {
      :fields => {:username => self.username, :business_id => self.business_id, :bury => toggle},
      :constraints => { :required => %w(username business_id bury) },
      :credentials => { :username => :api_username, :password => :api_key }
    }, :post
  end
end