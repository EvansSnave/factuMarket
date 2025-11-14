require "net/http"
require "uri"
require "json"

class AuditClient
  AUDIT_URL = "http://localhost:3001/auditoria"

  def self.send_event(event)
    uri = URI(AUDIT_URL)

    Net::HTTP.post(
      uri,
      { event: event.merge(service: "clients-microservice") }.to_json,
      "Content-Type" => "application/json"
    )
  rescue => e
    Rails.logger.error "El evento no fue enviado al microservicio de auditoria: #{e.message}"
  end
end
