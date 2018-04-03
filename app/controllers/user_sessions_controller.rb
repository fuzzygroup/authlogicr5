class UserSessionsController < ApplicationController
  
  ###skip_before_action :require_login, only: [:new, :create]
  
  def new
    @user_session = UserSession.new
  end

  def create
    #@user_session = UserSession.new(user_session_params)
    @user_session = UserSession.new(user_session_params.to_hash)
    #raise user_session_params.inspect
    if @user_session.save
      puts "Got into if condition success"
      flash[:success] = "Welcome back!"
      u_obj = User.where(:email => user_session_params["email"]).first
      l = Login.new
      l.date_created_at = Time.now
      l.user_id = u_obj.id
      l.login_type = "game_nanny_site"
      l.ip_address = request.remote_ip
      l.user_agent = request.user_agent
      if l.save
      else
        raise l.error.full_messages
      end
      
      #redirect_to "/home" and return
      redirect_back_or_default("/")
      #redirect_to "/home", success: "#{@user_session.inspect}" and return
    else
      puts "got into else failure condition "
      flash[:notice] = @user_session.errors.full_messages
      render :new
    end
    if l && l.user_id.nil?
      l.update_attribute(:user_id, u_obj.id)
    end
  end

  def destroy
    current_user_session.destroy
    flash[:success] = "Goodbye!"
    redirect_to root_path
  end

  private

  def user_session_params
    params.require(:user_session).permit(:email, :password, :remember_me)
  end
end