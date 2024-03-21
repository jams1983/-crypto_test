require 'net/http'
require 'openssl'
require 'date'
require 'json'

module CoinApi
  class Client
    def initialize(api_key:, options: {})
      @api_key = api_key
      @options = default_options.merge(options)
    end

    def exchange_rates_get_specific_rate(asset_id_base:, asset_id_quote:, parameters: {})
      endpoint = "exchangerate/#{asset_id_base}/#{asset_id_quote}"
      exchange_rate = request(endpoint: endpoint, parameters: parameters)
      pp exchange_rate
      exchange_rate[:time] = DateTime.parse(exchange_rate[:time])
      exchange_rate
    end

    def exchange_rates_get_all_current_rates(asset_id_base:)
      all_rates = request(endpoint: "exchangerate/#{asset_id_base}")
      all_rates[:rates].collect! do |rate|
        rate[:time] = DateTime.parse(rate[:time])
        rate
      end
    end

    private
    def default_headers
      headers = {}
      headers['X-CoinAPI-Key'] = @api_key
      headers['Accept'] = 'application/json'
      headers['Accept-Encoding'] = 'deflate, gzip'
      headers
    end

    def default_options
      options = {}
      options[:production] = true
      options
    end

    def headers
      default_headers.merge(@options.fetch(:headers, {}))
    end

    def base_url
      if @options[:production]
        'https://rest.coinapi.io/v1/'
      else
        'https://rest-test.coinapi.io/v1/'
      end
    end

    def response_compressed?
      headers['Accept-Encoding:'] == 'deflate, gzip'
    end

    def request(endpoint:, parameters: {})
      uri = URI.join(base_url, endpoint)
      uri.query = URI.encode_www_form(parameters)
      request = Net::HTTP::Get.new(uri)
      request.initialize_http_header(headers)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
    # uncomment only in development enviroment if ruby don't have trusted CA directory
    #http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      response = http.request(request)
      JSON.parse(response.body, symbolize_names: true)
    end
  end
end
