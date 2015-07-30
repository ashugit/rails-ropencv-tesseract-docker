TESSDATA_PREFIX="/usr/share/tesseract-ocr"
require 'tesseract'

Rails.Tesseract = Tesseract::Engine.new {|e|
  e.language  = :eng
  e.blacklist = '|'
}
