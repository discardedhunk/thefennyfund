module PaypalStuff

require 'net/http'
require 'net/https'
require 'uri'

PAYPAL_CONFIG = YAML.load_file("#{RAILS_ROOT}/config/paypal.yml")[RAILS_ENV]

  class Pdt
    def self.pdt_verify(tx_id)
      success = false
      RAILS_DEFAULT_LOGGER.debug "\npdt_verify: url= #{PAYPAL_CONFIG['url']}\n"
      http = Net::HTTP.new(PAYPAL_CONFIG['url'], 443)
      http.use_ssl = true

      req = "cmd=_notify-synch&tx=#{tx_id}&at=#{PAYPAL_CONFIG['id_token']}"
      RAILS_DEFAULT_LOGGER.debug "\npdt_verify: req= #{req}\n"
      resp, data = http.post(PAYPAL_CONFIG['path'], req)
      RAILS_DEFAULT_LOGGER.debug "\nCode = #{resp.code}\n"
      RAILS_DEFAULT_LOGGER.debug "\nMessage = #{resp.message}\n"
      resp.each {|key, val| puts key + ' = ' + val}
      RAILS_DEFAULT_LOGGER.debug "\nDATA= #{data}\n"

      data.gsub!(/\n/, '<br/>')

      if data.include?("SUCCESS") && data.include?(tx_id)
        success = true
        msg = "PayPal response:<br/><br/>" + data
      else
        msg = "PayPal response:<br/><br/>#{data}"
      end

      return success,msg
    end


  end

end


