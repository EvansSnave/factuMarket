Rails.application.routes.draw do
  post "/auditoria", to: "events#create"
  get "/auditoria/:id", to: "events#getBill"
end
