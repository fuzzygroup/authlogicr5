# from seira_watch_web_app
# class ApplicationController < ActionController::Base
#   protect_from_forgery with: :exception
#
#   before_action :show_flash
#
#   before_action :better_errors_hack, if: -> { Rails.env.development? }
#
#   before_action do
#     if current_user && current_user.is_admin?
#       Rack::MiniProfiler.authorize_request
#     end
#   end
#
#
#   def better_errors_hack
#     request.env['puma.config'].options.user_options.delete :app
#   end
#
#
#   private
#
#   def show_flash
#     flash.now[:notice] = "Found the about page!" if request.path == '/pages/about'
#   end
#
#   def current_user_session
#     return @current_user_session if defined?(@current_user_session)
#     @current_user_session = UserSession.find
#   end
#
#   def current_user
#     return @current_user if defined?(@current_user)
#     @current_user = current_user_session && current_user_session.user
#   end
#
#
#   def require_user
#     unless current_user
#       store_location
#       flash[:notice] = "You must be logged in to access this page"
#       #redirect_to new_user_session_url
#       redirect_to sign_in_path
#       return false
#     end
#   end
#
#   def require_login
#     redirect_to login_path unless logged_in?
#   end
#
#   def require_admin_user
#     if current_user.nil? || (current_user && current_user.admin? == false)
#       flash[:notice] = "You must be a logged in admin user to access this page"
#       redirect_to sign_in_path
#       return false
#     end
#     return true
#   end
#
#   def get_zero_account_redirect
#
#       if current_user.has_teacher?
#         return "/welcome/your_course"
#       elsif current_user.has_courses?
#         return "/welcome/competitor"
#       elsif current_user.has_competitor?
#         return "/welcome/competitor_course"
#       elsif current_user.has_competitor_courses?
#         return "/welcome/you"
#       else
#         return "/welcome/you"
#       end
#
#   end
#
#   def zero_account_check
#     if current_user.has_zero_accounts? || Metric.count == 0
#       path = get_zero_account_redirect
#       redirect_to path and return
#     end
#   end
#
#   def store_location
#     session[:return_to] = request.url
#   end
#
#   # todo add account status
#   def only_allow_logged_in_access
#     # TODO need to fix store_location
#     return true if current_user || current_user && current_user.is_admin?
#     redirect_to login_path
#   end
#
#
#
#   def valid_api_key?
#     return true if params[:api_key] == HYDE_API_KEY
#     return false
#   end
#
#   def invalid_api_key
#     head :unauthorized
#   end
#
#   def send_invalid_api_key
#     head :unauthorized
#   end
#
#
#   def validate_api_key
#     #return true
#     render(:status => :bad_request, nothing: true) and return unless valid_api_key?(params[:api_key])
#   end
#
#   helper_method :current_user_session, :current_user
#
#
# end
#







class ApplicationController < ActionController::Base
  #protect_from_forgery with: :exception
  # https://github.com/xargr/rails_deploy/issues/2z
  #protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
  protect_from_forgery prepend: true
  #protect_from_forgery with: :reset_session

  before_action :show_flash

  before_action :better_errors_hack, if: -> { Rails.env.development? }

  #skip_before_action :verify_authenticity_token
  
  #protect_from_forgery with: :exception


  #before_action :require_login

  helper_method :current_user_session, :current_user

  #helper_method :logged_in?


  def better_errors_hack
    request.env['puma.config'].options.user_options.delete :app
  end

  before_action do
    if Rails.env.development? && current_user && current_user.is_admin?
      Rack::MiniProfiler.authorize_request
    end
  end



  private

  def better_errors_hack
    request.env['puma.config'].options.user_options.delete :app
  end


  def show_flash
    #flash.now[:notice] = "Found the about page!" if request.path == '/pages/about'
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end
  

  # def logged_in?
  #   !! current_user_session
  # end
  #
  # def require_login
  #   redirect_to login_path unless logged_in?
  # end


  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to new_user_session_url
      return false
    end
  end

  def store_location
    #session[:return_to] = request.request_uri
    session[:return_to] = request.url
  end

  def only_allow_logged_in_access
    return true if current_user #|| current_user && current_user.is_admin?
    store_location
    redirect_to login_path
  end


  def valid_api_key?
    return true if params[:api_key] == HYDE_API_KEY
    return false
  end

  def invalid_api_key
    head :unauthorized
  end

  def send_invalid_api_key
    head :unauthorized
  end

  def validate_api_key
    #return true
    render(:status => :bad_request, nothing: true) and return unless valid_api_key?(params[:api_key])
  end
  
  # def store_location
  #   session[:return_to] = request.request_uri
  # end
  
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end



  protected


  # def handle_unverified_request
  #   # raise an exception
  #   fail ActionController::InvalidAuthenticityToken
  #   # or destroy session, redirect
  #   if current_user_session
  #     current_user_session.destroy
  #   end
  #   redirect_to root_url
  # end
  
  # def handle_unverified_request
  #     super
  #     flash.now[:warning] = 'Your session has expired, please log in again'
  #   end

end
