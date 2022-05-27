class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :load_user, except: %i(index create new)

  def edit
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = "Cập nhật tài khoản thành công"
      redirect_to edit_user_path(@user)
    else
      flash.now[:danger] = "Cập nhật người dùng thất bại"
    end
  end

  private

  def user_params
    params.require(:user).permit :email, :user_name, :password, :password_confirmation, :avatar
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = "Không tìm thấy người dùng"
    redirect_to root_path
  end
end
