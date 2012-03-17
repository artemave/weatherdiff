class UsersController < ApplicationController
	layout 'locations'
  # render new.rhtml
  def new
    if_registration_allowed do
      @user = User.new
    end
  end
 
  def create
    if_registration_allowed do
      logout_keeping_session!
      @user = User.new(params[:user])
      success = @user && @user.save
      if success && @user.errors.empty?
        # Protects against session fixation attacks, causes request forgery
        # protection if visitor resubmits an earlier form using back
        # button. Uncomment if you understand the tradeoffs.
        # reset session
        self.current_user = @user # !! now logged in
        redirect_back_or_default('/')
        flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
      else
        flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
        render :action => 'new'
      end
    end
  end

  protected

    def if_registration_allowed
      if Rails.env.production?
        flash[:error] = "Registration disabled"
        redirect_back_or_default '/'
      else
        yield
      end
    end
end
