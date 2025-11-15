require "net/http"
require "uri"
require "json"

class BillsClient
  BILLS_URL = "http://localhost:3002/facturas"

  def self.get_bill(id)
    uri = URI("#{BILLS_URL}/#{id}")
    response = Net::HTTP.get_response(uri)

    if response.is_a?(Net::HTTPSuccess)
      body = response.body
      begin
        data = JSON.parse(body)
      rescue JSON::ParserError
        return nil
      end

      # If parsed successfully but is not a Hash, treat as not found
      return nil unless data.is_a?(Hash)

      # "error" key means user doesn't exist
      return nil if data["error"].present?

      # empty hash "{}" means user not found
      return nil if data.empty?

      return data
    elsif response.is_a?(Net::HTTPNotFound)
      return nil
    else
      Rails.logger.error "Error consultando factura #{id}: #{response.code}"
      return nil
    end
  end

  def self.bill_exists?(id)
    !!get_bill(id)
  end
end
