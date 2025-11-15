require "net/http"
require "uri"
require "json"

class ClientsClient
  CLIENTS_URL = "http://localhost:3000/clientes"

  def self.get_user(id)
    uri = URI("#{CLIENTS_URL}/#{id}")
    response = Net::HTTP.get_response(uri)

    if response.is_a?(Net::HTTPSuccess)
      body = response.body

      begin
        data = JSON.parse(body)
      rescue JSON::ParserError
        return nil
      end

      return nil unless data.is_a?(Hash)

      return nil if data["error"].present?

      return nil if data.empty?

      return data
    elsif response.is_a?(Net::HTTPNotFound)
      return nil
    else
      Rails.logger.error "Error consultando usuario #{id}: #{response.code}"
      return nil
    end
  end

  def self.user_exists?(id)
    !!get_user(id)
  end
end
