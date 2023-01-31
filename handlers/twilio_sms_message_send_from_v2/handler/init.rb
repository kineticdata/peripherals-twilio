# Require the dependencies file to load the vendor libraries
require 'net/https'
require 'rexml/document'

class TwilioSmsMessageSendFromV2
  def initialize(input)
    # Set the input document attribute
    @input_document = REXML::Document.new(input)

    # Store the info values in a Hash of info names to values.
    @info_values = {}
    REXML::XPath.each(@input_document,"/handler/infos/info") { |item|
      @info_values[item.attributes['name']] = item.text
    }
    @enable_debug_logging = @info_values['enable_debug_logging'] == 'Yes'

    # Store parameters values in a Hash of parameter names to values.
    @parameters = {}
    REXML::XPath.match(@input_document, '/handler/parameters/parameter').each do |node|
      @parameters[node.attribute('name').value] = node.text.to_s
    end
  end


  def execute
    api_route = "https://api.twilio.com/2010-04-01/Accounts/#{@info_values['account_sid']}/Messages.json"

    payload = {
      "From" => @parameters['from'],
      "To" => @parameters['to'],
      "Body" => @parameters['message']
    }

    res = http_post(api_route, payload, {}, http_basic_headers(@info_values['account_sid'], @info_values['auth_token']))

    if !res.kind_of?(Net::HTTPSuccess)
      raise "Twilio Send handler failed: #{res.body}"
    end

    # Build the results XML
    return "<results/>\n"
  end

  # This is a template method that is used to escape results values (returned in
  # execute) that would cause the XML to be invalid.  This method is not
  # necessary if values do not contain character that have special meaning in
  # XML (&, ", <, and >), however it is a good practice to use it for all return
  # variable results in case the value could include one of those characters in
  # the future.  This method can be copied and reused between handlers.
  def escape(string)
    # Globally replace characters based on the ESCAPE_CHARACTERS constant
    string.to_s.gsub(/[&"><]/) { |special| ESCAPE_CHARACTERS[special] } if string
  end
  # This is a ruby constant that is used by the escape method
  ESCAPE_CHARACTERS = {'&'=>'&amp;', '>'=>'&gt;', '<'=>'&lt;', '"' => '&quot;'}

  #-----------------------------------------------------------------------------
  # The following Http helper methods are provided within this handler because
  # task currently doesn't have a common http client module that handlers can
  # use. If these methods were packaged as a module within the dependencies.rb
  # file or within a gem/library, they would be under the same constraints as
  # other vendor gems, such as RestClient, where any handler that uses
  # RestClient is currently stuck using v1.6.7. Adding these methods
  # directly to the handler class gives the freedom to add/modify as needed
  # without affecting other handlers.
  #-----------------------------------------------------------------------------


  #-----------------------------------------------------------------------------
  # HTTP HEADERS
  #-----------------------------------------------------------------------------

  def http_json_headers
    {
      "Accept" => "application/json",
      "Content-Type" => "application/json"
    }
  end
  
  
  def http_basic_headers(username, password)
    http_json_headers.merge({
      "Authorization" => "Basic #{Base64.strict_encode64("#{username}:#{password}")}"
    })
  end


  #-----------------------------------------------------------------------------
  # REST ACTIONS
  #-----------------------------------------------------------------------------
  
  def http_post(url, payload, parameters, headers, http_options={})
    uri = URI.parse(url)
    uri.query = URI.encode_www_form(parameters) unless parameters.empty?
    request = Net::HTTP::Post.new(uri, headers)
    request.set_form_data(payload)
    send_request(request, http_options)
  end


  #-----------------------------------------------------------------------------
  # LOWER LEVEL METHODS
  #-----------------------------------------------------------------------------

  def send_request(request, http_options={})
    uri = request.uri
    Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      configure_http(http, http_options)
      http.request(request)
    end
  end
  
  
  def build_http(uri, http_options={})
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl= true if (uri.scheme == 'https')
    configure_http(http, http_options)
    http
  end


  def configure_http(http, http_options={})
    http_options_sym = (http_options || {}).inject({}) { |h, (k,v)| h[k.to_sym] = v; h }
    http.verify_mode = http_options_sym[:ssl_verify] || OpenSSL::SSL::VERIFY_PEER if http.use_ssl?
    http.read_timeout= http_options_sym[:read_timeout] unless http_options_sym[:read_timeout].nil?
    http.open_timeout= http_options_sym[:open_timeout] unless http_options_sym[:open_timeout].nil?
  end
end