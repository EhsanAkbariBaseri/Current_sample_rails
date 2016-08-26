module SessionsHelper

  # Just  adds user id to session
  def log_in(user)
    session[:user_id] = user.id
  end

  # Gets the current user from session or from saved cookie
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember,cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # Checks if the user is logged in
  def logged_in?
    !current_user.nil?
  end

  # Deletes user_id from session
  def log_out
    forget current_user
    session.delete(:user_id)
    @current_user = nil
  end

  # Saves a remember digest in DB and save one in cookies
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # Removes the password digest from DB and cookies
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def current_user?(user)
    user==current_user
  end

  # Redirects to the saved URL in session
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default) # If session[:forwarding_url] is nil it goes to the default
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed.
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
    # It returns the URL which user tried to get access
    # request.get? checks if the request type is GET HTTP request
  end

end
