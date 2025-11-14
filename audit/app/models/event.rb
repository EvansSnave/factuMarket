class Event
  include Mongoid::Document
  include Mongoid::Timestamps

  store_in collection: "events"

  field :type, type: String
  field :service, type: String
  field :state, type: String
  field :entity_id, type: String
  field :payload, type: Hash
  field :description, type: String
end
