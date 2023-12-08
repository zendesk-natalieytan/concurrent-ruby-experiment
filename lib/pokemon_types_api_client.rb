# frozen_string_literal: true

require 'faraday'
require 'concurrent-ruby' # updated require

# Api Client to compare sequential vs concurrent requests using promises
# https://pokeapi.co/ (API Documentation)
class PokemonTypesApiClient
  BASE_URL = 'https://pokeapi.co/api/v2/type'
  TIMEOUT = 5
  TOTAL_NUMBERS = 20
  # There are only 18 Pokemon types. Set to 20 to simulate handling errors

  def initialize
    @client = Faraday.new(BASE_URL, request: { timeout: TIMEOUT }) do |connection|
      connection.request  :url_encoded
      connection.response :json, content_type: :json
      connection.response :raise_error
      connection.adapter  Faraday.default_adapter
    end
  end

  def bulk_pokemon_types
    (1..TOTAL_NUMBERS).map { |number| pokemon_type(number) }.compact.sort
  end

  def bulk_pokemon_types_with_promise
    requests = (1..TOTAL_NUMBERS).map { |number| pokemon_type_with_promise(number) }
    requests.map { |future| handle_pokemon_type_request(future.method(:value)) }.compact.sort
  end

  private

  def pokemon_type_with_promise(number)
    request_with_promise(method: :get, endpoint: number.to_s)
  end

  def pokemon_type(number)
    handle_pokemon_type_request(-> { request(method: :get, endpoint: number.to_s) })
  end

  def request(method:, endpoint:, params: {}, headers: {})
    @client.public_send(method) do |req|
      req.url(endpoint)
      req.headers = headers if headers.any?
      req.params = params if params.any?
    end
  end

  def request_with_promise(method:, endpoint:, params: {}, headers: {})
    Concurrent::Promises.future { request(method: method, endpoint: endpoint, params: params, headers: headers) }
  end

  def handle_pokemon_type_request(proc)
    response = proc.call
    JSON.parse(response.body)['name'] if response
  rescue Faraday::ResourceNotFound
    nil
  rescue JSON::ParserError
    nil
  end
end
