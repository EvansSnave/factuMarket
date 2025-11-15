class UsersController < ApplicationController
  include UsersHelper

  def home
    @routes = client_routes
    @user = User.new

    if params[:commit] == "Crear usuario"
      @user = UserService.create_user(user_params)
    end

    if params[:show_all].present?
      @all_users = UserService.get_all_users
    end

    if params[:search_id].present?
      @requestedUser = UserService.get_user_by_id(params[:search_id])
    end
  end

  def create
    user = UserService.create_user(user_params)
    if user.persisted?
      flash[:success] = "Usuario creado correctamente"
    else
      flash[:error] = user.errors.full_messages.join(", ")
    end

    redirect_to :controller => "users", :action => "home"
  end

  def getAll
    users = UserService.get_all_users

    render json: users
  end

  def getUser 
    id = params[:id]
    user = UserService.get_user_by_id(id)
    if user.present?

      render json: user
    else

      render json: { errors: "El cliente con id #{id} no existe" }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :identification)
  end
end
