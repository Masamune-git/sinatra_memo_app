# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'securerandom'

memo_dates = []

get '/' do
  @title = 'top'
  @memo_dates = memo_dates
  erb :top
end

get '/edit_memo/:id' do
  @title = 'Edit memo'
  @memo_date = memo_dates.find{|memo_date|
  memo_date["memo_id"] == params[:id]
  }
  erb :edit_memo
end

get '/show_memo/:id' do
  @title = 'Show memo'
  @memo_date = memo_dates.find{|memo_date| 
    memo_date["memo_id"] == params[:id]
  }
  erb :show_memo
end

get '/delete/:id' do
  redirect '/'
end

get '/new_memo' do
  @title = 'New memo'
  erb :new_memo
end

post '/new_memo/add' do
  memo_date = {
    "memo_name" => params[:memo_name],
    "memo_id"=> SecureRandom.uuid,
    "memo_text" => params[:memo_text]
}
  memo_dates << memo_date
  redirect '/'
end
