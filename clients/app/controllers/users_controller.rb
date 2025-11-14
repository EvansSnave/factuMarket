class UsersController < ApplicationController
  # POST /client
  def create
    user = User.new(user_params)

    if user.save
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
end
