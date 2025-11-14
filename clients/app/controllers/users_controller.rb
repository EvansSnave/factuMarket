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
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def getAll
    render json: User.all
  end

  def getUser 
    render json: User.find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :identification)
  end

  def send_audit_event(data)
    AuditClient.send_event(data)
  end
end
