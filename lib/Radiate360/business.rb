Radiate360::Business = Struct.new :api_username, :api_key, :username, :business_id do
  include StructExtensions

  def pause(toggle)
    Radiate360.call "businesses/#{self.business_id}/pause/#{toggle.to_s}", {
      :fields => {:username => self.username},
      :constraints => { :required => %w(username) },
      :credentials => { :username => self.api_username, :password => self.api_key }
    }, :post
  end
  
  def bury(toggle)
    Radiate360.call "businesses/#{self.business_id}/bury/#{toggle.to_s}", {
      :fields => {:username => self.username},
      :constraints => { :required => %w(username) },
      :credentials => { :username => self.api_username, :password => self.api_key }
    }, :post
  end
end