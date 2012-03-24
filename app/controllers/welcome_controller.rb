require 'google/api_client'


class WelcomeController < ApplicationController
  
  helper_method :auth, :user
  
  
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
    a = request.env['omniauth.auth']
    
#    response = client.execute(
#  plus.activities.list,
#  {'userId' => 'me', 'collection' => 'public'}
#)
    
    session[:auth] = a
    session[:credentials] = a['credentials']
    
    logger.debug("auth: #{a}")
    logger.debug("credentials: #{credentials}")
    
    redirect_to :action => :show
  end
  
  
  # --------------------------------------------------------
  # Die Show-Action zeigt Informationen zum eingeloggten User.
  # 
  # --------------------------------------------------------  
  def show
    if (user.nil?) then
      u = Hash.new()
      
      client = Google::APIClient.new
      plus = client.discovered_api('plus')
      client.authorization.access_token = credentials.token  # Mash
      
      resp = client.execute(plus.people.get, {"userId" => "me"})
      
      logger.debug("resp #{resp.data.public_methods.sort}")
      
      # liefert im data-Feld eine Google::APIClient::Schema::Plus::V1::Person
      # public_methods: [:!, :!=, :!~, :<=>, :==, :===, :=~, :[], :[]=, :__id__,
      #:__send__, :`, :about_me, :about_me=, :acts_like?, :as_json, :birthday,
      #:birthday=, :blank?, :breakpoint, :capture, :class, :class_eval, :clone,
      #:current_location, :current_location=, :debugger, :define_singleton_method,
      #:display, :display_name, :display_name=, :dup, :duplicable?, :emails, :emails=,
      #:enable_warnings, :enum_for, :eql?, :equal?, :etag, :etag=, :eval_js, :extend,
      #:freeze, :frozen?, :gem, :gender, :gender=, :has_app, :has_app=, :hash,
      #:html_safe?, :id, :id=, :image, :image=, :in?, :initialize_clone, :initialize_dup,
      #:inspect, :instance_eval, :instance_exec, :instance_of?, :instance_values,
      #:instance_variable_defined?, :instance_variable_get, :instance_variable_names,
      #:instance_variable_set, :instance_variables, :is_a?, :kind, :kind=, :kind_of?,
      #:languages_spoken, :languages_spoken=, :load, :load_dependency, :method,
      #:method_missing, :methods, :name, :name=, :nickname, :nickname=, :nil?,
      #:object_id, :object_type, :object_type=, :organizations, :organizations=,
      #:places_lived, :places_lived=, :presence, :present?, :private_methods,
      #:protected_methods, :psych_to_yaml, :psych_y, :public_method, :public_methods,
      #:public_send, :quietly, :relationship_status, :relationship_status=, :require,
      #:require_association, :require_dependency, :require_or_load, :respond_to?,
      #:respond_to_missing?, :send, :silence, :silence_stderr, :silence_stream,
      #:silence_warnings, :singleton_class, :singleton_methods, :suppress,
      #:suppress_warnings, :tagline, :tagline=, :taint, :tainted?, :tap, :to_enum,
      #:to_hash, :to_json, :to_param, :to_query, :to_s, :to_yaml, :to_yaml_properties,
      #:trust, :try, :unloadable, :untaint, :untrust, :untrusted?, :url, :url=,
      #:urls, :urls=, :valid?, :with_options, :with_warnings]
      
      h = resp.data.to_hash()
      m = Hashie::Mash.new(h)
      @person_me = m

    end
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
  
  
  # --------------------------------------------------------
  # Helper für das User-Objekt. 
  # 
  # --------------------------------------------------------
  def user
    session[:user]
  end
  
  
  def credentials
    session[:credentials]
  end

  
  
end
