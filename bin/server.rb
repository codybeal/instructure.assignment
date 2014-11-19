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

  file_name = params['myfile'][:filename]
  complete_file_name = 'uploads/' + file_name

  File.open(complete_file_name, 'w') do |f|
    f.write(params['myfile'][:tempfile].read)
  end

  uploader = Uploader.new
  uploader.write_to_table complete_file_name

  haml :upload_success
end

get '/courses' do
  uploader = Uploader.new
  uploader.get_courses.to_s
end

get '/students/:course' do
  uploader = Uploader.new
  uploader.get_students(params[:course]).to_s
end