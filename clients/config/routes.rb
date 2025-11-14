Rails.application.routes.draw do
  post "/clientes", to: "users#create"
end
