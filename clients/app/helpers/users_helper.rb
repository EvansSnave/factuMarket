module UsersHelper
  def client_routes
    [
      {
        method: "GET",
        endpoint: "/clientes",
        description: "Obtiene todos los clientes guardados en Oracle"
      },
      {
        method: "GET",
        endpoint: "/clientes/:id",
        description: "Obtiene un cliente segun su ID"
      },
      {
        method: "POST",
        endpoint: "/clientes",
        description: "Crea un nuevo cliente"
      }
    ]
  end
end
