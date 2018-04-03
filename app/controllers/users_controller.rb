class UsersController < ApplicationController
  def index
    @users = User.order("id DESC").page(params[:page])
  end
  
  def show
  end
  
  def new
    #redirect_to "/pricing" and return
    @user = User.new
  end

  def create
    #debugger
    if user_params[:tos].blank? || user_params[:tos] == "0"
      flash[:warning] = "You must accept the Terms of Service in order to sign up"
      redirect_to "/users/new" and return
    end
    
    @user = User.new
    @user.email = user_params[:email]
    @user.username = user_params[:username]
    @user.pwpt = user_params[:password]
    @user.password = user_params[:password]
    @user.password_confirmation = user_params[:password_confirmation]
    @user.first_name = user_params[:first_name]
    @user.subscription_type = user_params[:subscription_type]
    # note it requires an api call from SHOP to set this active
    @user.active = true
    @user.confirmed = true
    @user.approved = true

    if @user.save
      
      redirect_to jobs_path and return
      # begin
      #   #debugger
      #   ShopAppApi.create_user(user_params[:email], user_params[:password], user_params[:first_name], "")
      #   redirect_to "#{SERVERS[:game_nanny_shop][Rails.env.to_s]}?email=#{user_params[:email]}" and return
      # rescue StandardError => e
      #   flash[:notice] = "Unable to create user account - please contact support - Don't worry we'll get this fixed asap!"
      #   redirect_to "/" and return
      # end
      #
      # redirect_to SERVERS[:game_nanny_shop] and return
      # flash[:success] = "Account registered!"
      # if params[:creation_context] == "signup_form"
      #   #@user.create_database_and_add_root_user(users_params)
      #   redirect_to("#{SERVERS[:seira_watch_web_app][Rails.env.to_s]/welcome}") and return
      # else
      #   redirect_to root_path
      # end
    else
      flash[:warning] = @user.errors.full_messages
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :creation_context, :first_name, :tos, :subscription_type)
  end
end