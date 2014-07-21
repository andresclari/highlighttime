class UsersController < ApplicationController
  before_action :set_user, :finish_signup

  def finish_signup
    if request.patch? && params[:user] #&& params[:user][:email]
      if @user.update(user_params)
        # current_user.skip_reconfirmation!
        sign_in(@user, :bypass => true)
        redirect_to personal_url, notice: 'Your profile was successfully updated.'
      else
        @show_errors = true
      end
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      accessible = [ :name, :email, :unconfirmed_email] # extend with your own params
      accessible << [ :password, :password_confirmation ] unless params[:user][:password].blank?
      params.require(:user).permit(accessible)
    end
end
