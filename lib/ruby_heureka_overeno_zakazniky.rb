require 'net/http'
require 'uri'
require 'json'

require "ruby_heureka_overeno_zakazniky/version"

module RubyHeurekaOverenoZakazniky
  
  HOST = 'https://api.heureka.cz/shop-certification/v2/'
  HEADER = {'Content-Type': 'application/json;charset=UTF-8'}
  
  def self.order_log apiKey, email, orderId = nil, productItemIds = [], debug = false
    
    url_action = 'order/log'
    
    body = {
      apiKey: apiKey,
      email: email,
      productItemIds: []
    }
    body[:orderId] = orderId unless orderId.nil?
    productItemIds.each do |itemId|
      body[:productItemIds] << itemId
    end
    
    uri = URI.parse(self::HOST + url_action)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE if Rails.env.development?
    http.set_debug_output($stdout) if debug
    
    request = Net::HTTP::Post.new(uri.request_uri)
    request.body = body.to_json
    request["Content-Type"] = 'application/json;charset=UTF-8'

    begin
      response = http.request(request)
    rescue OpenSSL::SSL::SSLError, Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
      puts "HEUREKA ERROR: #{e.inspect}"
    end
    
  end
end
