#!/usr/bin/env ruby
# encoding: utf-8

# Configuration:::::::::::::::::::::::::::::::::::::::::::::::::
SKIP_LAST_COUNT = 3 # Try not to repeat the last # of images

# Libraries:::::::::::::::::::::::::::::::::::::::::::::::::::::::
require 'bundler'
require 'sinatra/base'
require 'slim'
require 'sass'
require 'coffee-script'
require 'pp'
require 'fastimage'
require 'json'
require 'dimensions'

# Application:::::::::::::::::::::::::::::::::::::::::::::::::::
# Handle sass files
class SassHandler < Sinatra::Base
  set :views, File.dirname(__FILE__) + '/templates/sass'
  get '/css/*.css' do
    filename = params[:splat].first
    sass filename.to_sym
  end
end

# Handle coffee script files
class CoffeeHandler < Sinatra::Base
  set :views, File.dirname(__FILE__) + '/templates/coffee'
  get '/js/*.js' do
    filename = params[:splat].first
    coffee filename.to_sym
  end
end

# The server
class MyApp < Sinatra::Base
  use SassHandler
  use CoffeeHandler

  # Configuration:::::::::::::::::::::::::::::::::::::::::::::::
  set :public_folder, File.dirname(__FILE__) + '/public'
  set :views, File.dirname(__FILE__) + '/templates'
  set :bind, '0.0.0.0'

  set :old_files, []
  set :new_files, []
  set :last_shown, []

  # Route Handlers::::::::::::::::::::::::::::::::::::::::::::::
  get '/' do
    slim :index
  end

  get '/next' do
    
    selected_image = MyApp.next_file
    selected_image = MyApp.next_file while Dimensions.angle(selected_image) != 0

    info = {}
    info['filename'] = selected_image[8, selected_image.length - 6]
    width, height = FastImage.size(selected_image)
    info['degrees'] = Dimensions.angle(selected_image)
    info['width'] = width
    info['height'] = height
    info['title'] = 'Hallo'

    # selected_image[8,selected_image.length-6]
    info.to_json
  end

  def  self.next_file
    files = Dir[File.dirname(__FILE__) + '/public/images/**/*'].reject { |fn| File.directory?(fn) }
    new_files = settings.new_files + (files - settings.old_files)
    new_files = new_files.sort { |a, b| File.basename(a) <=> File.basename(b) }

    if new_files.empty?
      not_shown = files - settings.last_shown
      if not_shown.empty?
        selected_image = files.shuffle.first
      else
        selected_image = not_shown.shuffle.first
      end
    else
      selected_image = new_files.shift
    end

    settings.last_shown << selected_image
    settings.last_shown.shift if settings.last_shown.length > SKIP_LAST_COUNT
    settings.old_files = files
    settings.new_files = new_files

    selected_image
  end

end

MyApp.run! port: 4567, host: '0.0.0.0' if __FILE__ == $PROGRAM_NAME
