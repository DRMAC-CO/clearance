module Clearance
  class Configuration
    # Controls whether the sign up route is enabled.
    # Defaults to `true`. Set to `false` to disable user creation routes.
    # The setting is ignored if routes are disabled.
    # @param [Boolean] value
    # @return [Boolean]
    attr_writer :allow_sign_up

    # The domain to use for the clearance remember token cookie.
    # Defaults to `nil`, which causes the cookie domain to default to the
    # domain of the request. For more, see
    # [RFC6265](http://tools.ietf.org/html/rfc6265#section-5.2.3).
    # @return [String]
    attr_accessor :cookie_domain

    # A lambda called to set the remember token cookie expires attribute.
    # The lambda accepts the collection of cookies as an argument which
    # allows for changing the expiration according to those cookies.
    # This could be used, for example, to set a session cookie unless
    # a `remember_me` cookie was also present. By default, cookie expiration
    # is one year. For more on cookie expiration see
    # [RFC6265](http://tools.ietf.org/html/rfc6265#section-5.2.1).
    # @return [Lambda]
    attr_accessor :cookie_expiration

    # The name of Clearance's remember token cookie.
    # Defaults to `remember_token`.
    # @return [String]
    attr_accessor :cookie_name

    # Controls which paths the remember token cookie is valid for.
    # Defaults to `"/"` for the entire domain. For more, see
    # [RFC6265](http://tools.ietf.org/html/rfc6265#section-5.1.4).
    # @return [String]
    attr_accessor :cookie_path

    # Controls whether the HttpOnly flag should be set on the remember token
    # cookie. Defaults to `true`, which prevents the cookie from being made
    # available to JavaScript. For more see
    # [RFC6265](http://tools.ietf.org/html/rfc6265#section-5.2.6).
    # @return [Boolean]
    attr_accessor :httponly

    # Same-site cookies ("First-Party-Only" or "First-Party") allow servers to
    # mitigate the risk of CSRF and information leakage attacks by asserting
    # that a particular cookie should only be sent with requests initiated from
    # the same registrable domain.
    # Defaults to `nil`. For more, see
    # [RFC6265](https://tools.ietf.org/html/draft-west-first-party-cookies-06#section-4.1.1).
    # and https://github.com/rack/rack/blob/6eda04886e3a57918ca2d6a482fda02a678fef0a/lib/rack/utils.rb#L232-L244
    # @return [String]
    attr_accessor :same_site

    # Controls the address the password reset email is sent from.
    # Defaults to reply@example.com.
    # @return [String]
    attr_accessor :mailer_sender

    # The password strategy to use when authenticating and setting passwords.
    # Defaults to {Clearance::PasswordStrategies::BCrypt}.
    # @return [Module #authenticated? #password=]
    attr_accessor :password_strategy

    # The default path Clearance will redirect signed in users to.
    # Defaults to `"/"`. This can often be overridden for specific scenarios by
    # overriding controller methods that rely on it.
    # @return [String]
    attr_accessor :redirect_url

    # The default path Clearance will redirect signed out users to.
    # Defaults to `nil` so that the controller will use `sign_in_url`
    # for backwards compatibility. This can be set here instead of overriding
    # the method via an overridden session controller.
    # @return [String]
    attr_accessor :url_after_destroy

    # The default path Clearance will redirect non-users to when denied access.
    # Defaults to `nil` so that the authorization module will use `sign_in_url`
    # for backwards compatibility. This can be set here instead of overriding
    # the method via an overridden authorization module.
    # @return [String]
    attr_accessor :url_after_denied_access_when_signed_out

    # The flash hash returned when successfully signed in.
    # Defaults to `nil` so no flash is shown.
    # Example: sign_in_success_flash = {success: "You have signed in!"}
    # @return [Hash]
    attr_accessor :sign_in_success_flash

    # The flash hash returned when successfully logged out.
    # Defaults to `nil` so no flash is shown.
    # Example: sign_out_success_flash = {notice: "You have been logged out."}
    # @return [Hash]
    attr_accessor :sign_out_success_flash

    # Controls whether Clearance will rotate the CSRF token on sign in.
    # Defaults to `nil` which generates a warning. Will default to true in
    # Clearance 2.0.
    attr_accessor :rotate_csrf_on_sign_in

    # Set to `false` to disable Clearance's built-in routes.
    # Defaults to `true`. When set to false, your app is responsible for all
    # routes. You can dump a copy of Clearance's default routes with
    # `rails generate clearance:routes`.
    # @return [Boolean]
    attr_writer :routes

    # Controls the secure setting on the remember token cookie.
    # Defaults to `false`. When set, the browser will only send the
    # cookie to the server over HTTPS. You should set this value to true in
    # live environments to prevent session hijacking. For more, see
    # [RFC6265](http://tools.ietf.org/html/rfc6265#section-5.2.5).
    # @return [Boolean]
    attr_accessor :secure_cookie

    # Controls whether cookies are signed.
    # Defaults to `false` for backwards compatibility.
    # When set, uses Rails' signed cookies
    # (more secure against timing/brute-force attacks)
    # see [ActionDispatch::Cookies](https://api.rubyonrails.org/classes/ActionDispatch/Cookies.html)
    # @return [Boolean|:migrate]
    attr_reader :signed_cookie

    # The array of sign in guards to run when signing a user in.
    # Defaults to an empty array. Sign in guards respond to `call` and are
    # initialized with a session and the current stack. Each guard can decide
    # to fail the sign in, yield to the next guard, or allow the sign in.
    # @return [Array<#call>]
    attr_accessor :sign_in_guards

    # The ActiveRecord class that represents users in your application.
    # Defaults to `::User`.
    # @return [ActiveRecord::Base]
    attr_writer :user_model

    # The controller class that all Clearance controllers will inherit from.
    # Defaults to `::ApplicationController`.
    # @return [ActionController::Base]
    attr_writer :parent_controller

    # The array of allowed environments where `Clearance::BackDoor` is enabled.
    # Defaults to ["test", "ci", "development"]
    # @return [Array<String>]
    attr_accessor :allowed_backdoor_environments

    # The parameter for user routes. By default this is derived from the user
    # model.
    # @return [Symbol]
    attr_accessor :user_parameter

    # Controls wether users are automatically signed in after successfully
    # resetting their password.
    # Defaults to `true`.
    # @return [Boolean]
    attr_writer :sign_in_on_password_reset

    def initialize
      @allow_sign_up = true
      @allowed_backdoor_environments = ["test", "ci", "development"]
      @cookie_domain = nil
      @cookie_expiration = ->(cookies) { 1.year.from_now.utc }
      @cookie_name = "remember_token"
      @cookie_path = '/'
      @httponly = true
      @same_site = nil
      @mailer_sender = 'reply@example.com'
      @redirect_url = '/'
      @url_after_destroy = nil
      @url_after_denied_access_when_signed_out = nil
      @sign_in_success_flash = nil
      @sign_out_success_flash = nil
      @rotate_csrf_on_sign_in = true
      @routes = true
      @secure_cookie = false
      @signed_cookie = false
      @sign_in_guards = []
      @user_parameter = nil
      @sign_in_on_password_reset = true
    end

    def signed_cookie=(value)
      if [true, false, :migrate].include? value
        @signed_cookie = value
      else
        raise "Clearance's signed_cookie configuration value is invalid. " \
              "Valid values are true, false, or :migrate. " \
              "Set this option via Clearance.configure in an initializer"
      end
    end

    # The class representing the configured user model.
    # In the default configuration, this is the `User` class.
    # @return [Class]
    def user_model
      (@user_model || "User").to_s.constantize
    end

    # The class representing the configured base controller.
    # In the default configuration, this is the `ApplicationController` class.
    # @return [Class]
    def parent_controller
      (@parent_controller || "ApplicationController").to_s.constantize
    end

    # Is the user sign up route enabled?
    # @return [Boolean]
    def allow_sign_up?
      @allow_sign_up
    end

    # Specifies which controller actions are allowed for user resources.
    # This will be `[:create]` is `allow_sign_up` is true (the default), and
    # empty otherwise.
    # @return [Array<Symbol>]
    def  user_actions
      if allow_sign_up?
        [:create]
      else
        []
      end
    end

    # The name of user parameter for the configured user model.
    # This is derived from the `model_name` of the `user_model` setting.
    # In the default configuration, this is `user`.
    # @return [Symbol]
    def user_parameter
      @user_parameter ||= user_model.model_name.singular.to_sym
    end

    # The name of foreign key parameter for the configured user model.
    # This is derived from the `model_name` of the `user_model` setting.
    # In the default configuration, this is `user_id`.
    # @return [Symbol]
    def user_id_parameter
      "#{user_parameter}_id".to_sym
    end

    # @return [Boolean] are Clearance's built-in routes enabled?
    def routes_enabled?
      @routes
    end

    # Reloads the clearance user model class.
    # This is called from the Clearance engine to reload the configured
    # user class during each request while in development mode, but only once
    # in production.
    #
    # @api private
    def reload_user_model
      if @user_model.present?
        @user_model = @user_model.to_s.constantize
      end
    end

    def rotate_csrf_on_sign_in?
      !!rotate_csrf_on_sign_in
    end

    def sign_in_on_password_reset?
      @sign_in_on_password_reset
    end
  end

  # @return [Clearance::Configuration] Clearance's current configuration
  def self.configuration
    @configuration ||= Configuration.new
  end

  # Set Clearance's configuration
  # @param config [Clearance::Configuration]
  def self.configuration=(config)
    @configuration = config
  end

  # Modify Clearance's current configuration
  # @yieldparam [Clearance::Configuration] config current Clearance config
  # ```
  # Clearance.configure do |config|
  #   config.routes = false
  # end
  # ```
  def self.configure
    yield configuration
  end
end
