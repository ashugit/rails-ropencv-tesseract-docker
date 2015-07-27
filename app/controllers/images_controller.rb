require 'imaging/ropencv'
class ImagesController < ApplicationController
  include ROpenCV
  respond_to :json

  def try()
    get_image()
    respond_to do |format|
     format.json  { render :json => {:success => true}}
    end
  end
end
