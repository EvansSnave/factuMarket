class UsersController < ApplicationController
  # POST /clientes
  def create
    user = User.new(user_params)

    if user.save
      send_audit_event(
        type: "CLIENTE_CREADO",
        entity_id: user.id,
        description: "Un cliente fue creado",
        payload: user.as_json
      )

      render json: { message: "Cliente creado", user: user }, status: :created
    else
      send_audit_event(
        type: "CLIENTE_CREADO_ERROR",
        entity_id: 0,
        description: "Hubo un error al crear el cliente Error: #{user.errors.full_messages}",
        payload: {}
      )
      render json: { errors: "Hubo un error al crear el cliente Error: #{user.errors.full_messages}" }, status: :unprocessable_entity
    end
  end

  def getAll
    send_audit_event(
      type: "PETICION_CLIENTE",
      entity_id: 0,
      description: "Se enviaron todos los clientes",
      payload: User.all.as_json
    )

    render json: User.all
  end

  def getUser 
    id = params[:id]
    user = User.find_by(id: id) 
    if user.present?
      send_audit_event(
        type: "PETICION_CLIENTE",
        entity_id: user.id,
        description: "Se envio el cliente con id #{user.id}",
        payload: user.as_json
      )

      render json: user
    else
      send_audit_event(
        type: "PETICION_CLIENTE_ERROR",
        entity_id: 0,
        description: "El cliente con id #{id} no existe",
        payload: {}
      )

      render json: { errors: "El cliente con id #{id} no existe" }, status: :unprocessable_entity
    end

  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :identification)
  end

  def send_audit_event(data)
    AuditClient.send_event(data)
  end
end
