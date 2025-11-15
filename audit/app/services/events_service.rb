class EventsService
  def self.get_bill_events(bill_id)
    events = Event.where(service: "bills-microservice", :"entity_id" => bill_id.to_i)

    events
  end
end
