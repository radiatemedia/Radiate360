Radiate360::Configuration = Struct.new :username, :password, :base_url, :ssl, :logger do
  include StructExtensions

  def url
    self.base_url || Radiate360::BASE_URI
  end
  
  def version
    Radiate360::API_VERSION
  end
  
  def use_ssl
    self.ssl || false
  end

end
