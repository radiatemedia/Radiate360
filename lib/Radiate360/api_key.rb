Radiate360::ApiKey = Struct.new :username, :business_id do
  include StructExtensions

  def create
    Radiate360.call 'api_keys', 
                    { :fields => { :username => self.username, :business_id => self.business_id },
                      :required => %w(username business_id) },
                    :post
  end
end
