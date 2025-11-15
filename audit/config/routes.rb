Rails.application.routes.draw do
  get "/", to: "events#home"
  post "/auditoria", to: "events#create"
  get "/auditoria/:id", to: "events#get_bill_events"
end
