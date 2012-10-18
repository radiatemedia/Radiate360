# Defines a couple quality of life extensions to ruby's Struct, including
# instantiation of the generated class via a Hash and being able to call
# to_hash on the generated class to get the values back out in a non-array
# format.
module StructExtensions
  # Allows instantiation of a Struct's generated class through a Hash
  # or by the explicit arguments, which is default.
  # Example
  #   Person = Struct.new :first_name, :last_name do
  #     include StructExtensions
  #   end
  #   person = Person.new(:last_name => "Tolkien", :first_name => "John")
  # is equivalient to
  #   person = Person.new('John', 'Tolkien')
  def initialize(*args)
    if args[0].is_a?(Hash)
      args[0].each do |key, value|
        # depending on ruby version, members is an array or strings OR symbols,
        # make sure we know what we're working with
        self[key] = value if self.members.collect(&:to_s).include?(key.to_s)
      end
    else
      super(*args)
    end
  end

  def to_hash(options = {})
    options = {:only => self.members, :include => {}}.merge!(options)
    member_list = (options[:only] | options[:include].keys).collect(&:to_sym)

    member_list.select { |member| self.members.collect(&:to_sym).include?(member) }.inject({}) do |hashed, member|
      if self[member].respond_to?(:to_hash)
        opts = options[:include] && options[:include][member] ? {:only => options[:include][member]} : {}
        hashed[member] = self[member].to_hash(opts)
      else
        hashed[member] = self[member]
      end

      hashed
    end
  end
end
