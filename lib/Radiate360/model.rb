class Radiate360::Model #:nodoc:
  def initialize(attributes = {})
    # Assign all the attributes the instance variables
    attributes.each do |attr, value|
      if respond_to?("#{attr}=")
        send("#{attr}=", value)
      end
    end
  end

  def to_hash(options = {})
    attribute_list = []
    attribute_list += options[:only] unless options[:only].nil? || options[:only].empty?
    attribute_list = self.class.attributes if attribute_list.empty?
    attribute_list |= (options[:include] || {}).keys
    attribute_list = attribute_list.collect(&:to_sym)

    attribute_list.inject({}) do |hashed, attribute_name|
      val = send(attribute_name)
      if val.respond_to?(:to_hash)
        opts = options[:include] && options[:include][attribute_name]
        hashed[attribute_name] = val.to_hash(:only => opts || [])
      else
        hashed[attribute_name] = val
      end

      hashed
    end
  end

  def self.attributes
    @attributes ||= []
  end

  # Much the same as +attr_accessor+ however this keeps a list of all
  # attributes as well, so you can do things like the serialize method
  def self.attribute(*args)
    @attributes = attributes | args.collect(&:to_s)

    args.each do |arg|
      self.class_eval("def #{arg}; @#{arg}; end")
      self.class_eval("def #{arg}=(val); @#{arg} = val; end")
    end
  end

  def require_fields!(fields, options)
    fields = fields.collect{|f| f.to_sym }
    options ||= {}
    raise Radiate360::InvalidRequestError.new("Please supply all of the following required fields: %s" % fields.inspect) unless fields.none? { |field| options[field].nil? || options[field].empty? }
  end
end
