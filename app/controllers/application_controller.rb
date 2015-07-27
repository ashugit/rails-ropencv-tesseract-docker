class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def verify_token

    if params[:access_token]
      Rails.logger.info "No token sent in verify_token"
      access_token = params[:access_token]
      if Token.where(:access_token => access_token).first
        return true
      end
    end
    respond_to do |format|
     format.html  { render :inline => '<b>Access denied<b/>'.html_safe}
     format.json  { render :json => {:success => false}}
   end
  end

end
