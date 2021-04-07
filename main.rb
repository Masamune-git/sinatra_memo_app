require 'sinatra'
require 'sinatra/reloader'
require 'securerandom'
memo_names = []
memo_links = []

get '/' do 
  @title = 'top'
  @memo_names = memo_names
  erb :top
end

get '/new_memo' do 
  @title = 'new_memo'
  erb :new_memo
end

post "/new_memo/add" do 
  file_name = SecureRandom.uuid
  File.open("db/#{file_name}","w") do |text|
    text.puts( params[:memo_text] )
  end
  
  memo_names << params[:memo_name]
  memo_links << "db/#{file_name}"
  redirect '/'    
  erb :index
end
