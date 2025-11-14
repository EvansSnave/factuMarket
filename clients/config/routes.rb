Rails.application.routes.draw do
  get "/clientes", to: "users#getAll"
  get '/clientes/:id', to: 'users#getUser'
  post "/clientes", to: "users#create"
end
