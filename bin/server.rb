require 'rubygems'
require 'sinatra'
require 'haml'
require_relative 'uploader'

get '/' do
  'Hello World'
end

get '/upload' do
  haml :upload
end

post '/upload' do

  file_name = 'uploads/' + params['myfile'][:filename]

  File.open(file_name, 'w') do |f|
    f.write(params['myfile'][:tempfile].read)
  end

  uploader = Uploader.new
  uploader.write_to_table file_name

  return file_name + ' was successfully uploaded!'
end