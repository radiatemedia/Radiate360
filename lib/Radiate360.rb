module Radiate360
  # The root url of the Marketecture end point.
  BASE_URI    = "https://ccpz.radiatemedia.com".freeze
  API_VERSION = 1.freeze

  class Radiate360Error < StandardError; end
  class AuthenticationError < Radiate360Error; end
  class InvalidRequestError < Radiate360Error; end

  class << self
    # Returns an object holding the current configuration options for the API
    def config
      @@config ||= Radiate360::Configuration.new
    end

    # Configure the API with your Radiate360 conventions.
    # Current configuration options are
    # * username
    # * password
    def configure
      yield config
    end

    def call(api_action, params, method, &block)
      # apply some defaults so we don't have nil object errors
      params = { :fields => {},
                 :constraints => {},
                 :credentials => { :username => config.username,
                                   :password => config.password } }.merge( params )
      with_config params[:fields] do |parameters|
        validate(parameters, params[:constraints])
        http, request = setup_call(api_action, parameters, method)

        http.start do |http|
          log "Making API to #{http.address + request.path}. Parameters are: #{parameters.inspect}", :info
          res = http.request(request)
          log res.body, :debug
          if res.body.nil? || res.body.empty?
            log "Got response: #{res.code} location: #{res['location']}", :debug
            yield_for_block({}, block)
          else
            response = parse_response(res)
            log "Got response: #{response.inspect}", :debug
            yield_for_block(response['result'], block)
          end
        end
      end
    end

    def override_config(new_config)
      old_config = config.dup
      @@config = Radiate360::Configuration.new(config.to_hash.merge(new_config))
      yield
    ensure
      @@config = old_config
    end

    def log(msg, level = :debug)
      config.logger ? config.logger.send(level, msg) : nil
    end

    def yield_for_block(context, block)
      if block
        if block.arity < 1
          context.instance_eval &block
        else
          block.call(context)
        end
      else
        context
      end
    end

    private

    def secure_uri(uri)
      u = URI(uri)

      if config.use_ssl
        u.scheme = 'https'
      end

      URI(u.to_s)
    end

    def setup_call(action, params, method)
      uri = secure_uri(config.url + "/#{config.version}/#{action.to_s}")

      if method == :post
        request = Net::HTTP::Post.new(uri.path)
        request.set_form_data(params)
      else
        uri.query = params.collect { |key, value| [URI.encode(key.to_s), URI.encode(value.to_s)].join('=') }.join('&')
        request = Net::HTTP::Get.new(uri.request_uri)
      end

      request.basic_auth params[:credentials][:username], params[:credentials][:password]

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = config.use_ssl

      [http, request]
    end

    def validate(params, constraints)
      # Make sure we have all the required information
      # raise AuthenticationError.new('Please specify your username/password') if config.useranme.nil? || config.useranme.empty? || config.password.nil? || config.password.empty?
      if required_fields = constraints[:required]
        required_fields = %w(username business_id) if required_fields == :default

        missing_required_fields = (required_fields).select do |required_field|
          params[required_field.to_sym].nil? || params[required_field.to_sym].empty?
        end
        raise InvalidRequestError.new('Please specify the missing required fields to continue: %s' % missing_required_fields.join(',')) unless missing_required_fields.empty?
      end
    end

    def with_config(fields, &block)
      yield fields.merge(:username => config.username, :password => config.password)
    end

    # So, the response from CCPZ should be JSON
    # def parse_response(resp)
    #   begin
    #     doc = REXML::Document.new(resp.body)
    #   rescue Exception => e
    #     raise MarketectureError.new("An unknown error occured in the API: %s" % e.message)
    #   end
    # 
    #   case doc.elements["result/code"].text
    #   when "-1" then raise AuthenticationError.new(doc.elements["result/message"])
    #   when "0" then raise InvalidRequestError.new(doc.elements["result/message"])
    #   else
    #     hash_from_xml(doc)
    #   end
    # end
    # 
    # def hash_from_xml(document)
    #   hash = {}
    #   document.each_element do |elem|
    #     if elem.elements.empty?
    #       hash[elem.name] = elem.text
    #     else
    #       hash[elem.name] = hash_from_xml(elem)
    #     end
    #   end
    # 
    #   hash
    # end
  end
end

require 'Radiate360/models/api_key'
require 'Radiate360/models/business'
require 'Radiate360/configuration'
require 'net/http'
require 'net/https'
