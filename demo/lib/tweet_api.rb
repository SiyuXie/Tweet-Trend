require 'rubygems'
require 'oauth'

def api_request(uri)
  consumer_key = OAuth::Consumer.new(
      "EAqHMThvTcJOfjSjrOOT4JAzh",
      "PxWB9QeCJAoZlQWOn0v2OEmbFrWmBDfkKeo7p7qXwaHcrqqgbT")
  access_token = OAuth::Token.new(
      "3100074203-xAc1x5Pq3cTNb0S49DDkgKZalsnZhljIkw4U31t",
      "Rn9QKcjlYdjH96aViSUg6e5F8umriW00ABJaBilOyGI2L")

  address = URI(uri)

  # Set up Net::HTTP to use SSL, which is required by Twitter.
  http = Net::HTTP.new address.host, address.port
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_PEER

  # Build the request and authorize it with OAuth.
  request = Net::HTTP::Get.new address.request_uri
  request.oauth! http, consumer_key, access_token

  # return http.get(address)
  # Issue the request and return the response.
  http.start
  response = http.request request
  
  null = nil
  response_parsed = eval(response.body)
  
  if response_parsed.class == Hash
    if response_parsed[:error] != nil
      return nil
    end
  else
    # return response_parsed
    return response.body
  end
end

def get_statuses_retweets(status_id)
  uri = 'https://api.twitter.com/1.1/statuses/retweets/' + status_id.to_s + '.json'
  return api_request(uri)
end

def get_statuses_show(status_id)
  uri = 'https://api.twitter.com/1.1/statuses/show.json?id=' + status_id.to_s
  return api_request(uri)
end

def streaming_api_request(uri)
  data_buffer = ""

  consumer_key = OAuth::Consumer.new(
      "EAqHMThvTcJOfjSjrOOT4JAzh",
      "PxWB9QeCJAoZlQWOn0v2OEmbFrWmBDfkKeo7p7qXwaHcrqqgbT")
  access_token = OAuth::Token.new(
      "3100074203-xAc1x5Pq3cTNb0S49DDkgKZalsnZhljIkw4U31t",
      "Rn9QKcjlYdjH96aViSUg6e5F8umriW00ABJaBilOyGI2L")

  address = URI(uri)

  # Set up Net::HTTP to use SSL, which is required by Twitter.
  http = Net::HTTP.new address.host, address.port
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_PEER

  # Build the request and authorize it with OAuth.
  request = Net::HTTP::Get.new address.request_uri
  request.oauth! http, consumer_key, access_token

  # return http.get(address)
  # Issue the request and return the response.
  http.start

  http.request request do |response|
    response.read_body do |chunk|
      data_buffer += chunk
      # twitter use '\r\n' to seperate different tweets
      data_array = data_buffer.split("\r\n")
      i = 0
      while i < data_array.length - 1
        # yield intact tweet
        yield data_array[i]
        i += 1
      end
      data_buffer = data_array[i]
    end
  end
end

def get_statuses_sample
  puts 'starting'
  uri = 'https://stream.twitter.com/1.1/statuses/sample.json'
  streaming_api_request(uri) do |x|
    if x[2, 6] == 'delete'
      # is not tweet
      next
    else
      yield x
    end
  end
end



