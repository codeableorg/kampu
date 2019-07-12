class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:register, :login]

  def login
    user = User.valid_login?(params[:email], params[:password])
    if user
      regenerate_and_signed_token(user)
      render json: user
    else
      render json: { errors: 'Incorrect email or password' },
             status: :bad_request
    end
  end

  def register
    user = User.new(user_params)
    if user.save
      render json: user
    else
      render json: { errors: user.errors}, status: :bad_request
    end
   
  end

  def destroy
    current_user.invalidate_token
    cookies.delete :auth_token
    head :ok
  end

  private
  def user_params
    params.permit(:name, :email, :password, :role)
  end
end
