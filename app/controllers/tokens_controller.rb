require 'securerandom'
class TokensController < ApplicationController
  def new
  end

  def create
    Rails.logger.info "received secret #{params[:secret_key]}"
    if params[:secret_key].blank?
      Rails.logger.info "Nothing in secret"
      respond_to do |format|
        format.html  { render :inline => '<b>Access denied on secret<b/>'.html_safe}
      end
      return
    else
      if params[:secret_key] != "CHEESEPIZZAISAWESOME"
        respond_to do |format|
          format.html  { render :inline => '<b>Access denied on secret<b/>'.html_safe}
        end
        return
      end
    end
    t = Token.new
    t.access_token = SecureRandom.hex(15)
    t.save()
    respond_to do |format|
      format.html  { render :inline => "<b>Generated  Token : #{t.access_token}<b/>".html_safe}
    end
  end

  def index
  end
end
