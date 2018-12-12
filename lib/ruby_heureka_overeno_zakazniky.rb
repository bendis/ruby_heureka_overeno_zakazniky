require 'net/http'
require 'uri'
require 'json'

require "ruby_heureka_overeno_zakazniky/version"

module RubyHeurekaOverenoZakazniky
  
  HOST = 'https://api.heureka.cz/shop-certification/v2/'
  HEADER = {'Content-Type': 'application/json'}
  
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
    
    http.set_debug_output($stdout) if debug
    
    request = Net::HTTP::Post.new(uri.request_uri, self::HEADER)
    request.body = body.to_json

    response = http.request(request)
    
  end
end
