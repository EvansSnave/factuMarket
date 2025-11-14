Rails.application.routes.draw do
  get "/", to: "users#home"
    get '/clientes/:id', to: 'users#getUser'
  get "/clientes", to: "users#getAll"
  post "/clientes", to: "users#create"
end
