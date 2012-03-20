class WelcomeController < ApplicationController
  
  helper_method :auth
  
  
  def index
    render :welcome
  end
  
  
  # --------------------------------------------------------
  # Callback-Routine für Google. Speichert den Auth-Hash in
  # der Session.
  # 
  # Rendert die show View
  # --------------------------------------------------------
  def create_session
    session[:auth] = request.env['omniauth.auth']
    
    render :show
  end
  
  
  def failure
    render :ups
  end
  
  # --------------------------------------------------------
  # Helper für den Auth-Hash. 
  # 
  # --------------------------------------------------------
  def auth
    session[:auth]
  end
  
  
end
