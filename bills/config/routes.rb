Rails.application.routes.draw do
  get "/facturas", to: "bills#index"
  get "/facturas/:id", to: "bills#getBill"
  post "/facturas", to: "bills#create"
end
