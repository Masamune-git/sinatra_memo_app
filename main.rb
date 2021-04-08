# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'securerandom'

memo_dates = []

class Memo
  attr_accessor :memo_name, :memo_id
  def initialize(memo_name, memo_id)
    @memo_name = memo_name
    @memo_id = memo_id
  end
end

get '/' do
  @title = 'top'
  @memo_dates = memo_dates
  erb :top
end

get '/new_memo' do
  @title = 'new_memo'
  erb :new_memo
end

post '/new_memo/add' do
  memo_id = SecureRandom.uuid
  File.open("db/#{memo_id}", 'w') do |text|
    text.puts(params[:memo_text])
  end
  memo_dates << Memo.new(params[:memo_name].to_s, memo_id)
  redirect '/'
  erb :index
end
