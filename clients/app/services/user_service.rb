class UserService
  def self.create_user(params)
    user = User.new(params)

    if user.save
      self.send_audit_event(
        type: "CLIENTE_CREADO",
        entity_id: user.id,
        description: "Un cliente fue creado",
        payload: user.as_json
      )
    else
      self.send_audit_event(
        type: "CLIENTE_CREADO_ERROR",
        entity_id: 0,
        description: "Hubo un error al crear el cliente Error: #{user.errors.full_messages}",
        payload: {}
      )
    end

    user
  end

  def self.get_all_users
    self.send_audit_event(
      type: "PETICION_CLIENTE",
      entity_id: 0,
      description: "Se enviaron todos los clientes",
      payload: {
        count: User.count
      }
    )

    User.all
  end

  def self.get_user_by_id(id)
    user = User.find_by(id: id) 
    if user.present?
      send_audit_event(
        type: "PETICION_CLIENTE",
        entity_id: user.id,
        description: "Se envio el cliente con id #{user.id}",
        payload: user.as_json
      )
    else
      send_audit_event(
        type: "PETICION_CLIENTE_ERROR",
        entity_id: 0,
        description: "El cliente con id #{id} no existe",
        payload: {}
      )
    end

    user
  end

  private

  def self.send_audit_event(data)
    AuditClient.send_event(data)
  end
end
