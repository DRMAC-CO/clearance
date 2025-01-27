class Clearance::SessionsController < Clearance::BaseController
  before_action :redirect_signed_in_users, only: [:new]
  skip_before_action :require_login, only: [:create, :new, :destroy], raise: false

  def create
    @user = authenticate(params)

    sign_in(@user) do |status|
      if status.success?
        redirect_back_or url_after_create, flash: sign_in_success_flash
      else
        flash.now.alert = status.failure_message
        render template: "sessions/new", status: :unauthorized
      end
    end
  end

  def destroy
    sign_out
    redirect_to url_after_destroy, status: :see_other, flash: sign_out_success_flash
  end

  def new
    render template: "sessions/new"
  end

  private

  def redirect_signed_in_users
    if signed_in?
      redirect_to url_for_signed_in_users
    end
  end

  def sign_in_success_flash
    Clearance.configuration.sign_in_success_flash
  end

  def sign_out_success_flash
    Clearance.configuration.sign_out_success_flash
  end

  def url_after_create
    Clearance.configuration.redirect_url
  end

  def url_after_destroy
    Clearance.configuration.url_after_destroy || sign_in_url
  end

  def url_for_signed_in_users
    url_after_create
  end
end
