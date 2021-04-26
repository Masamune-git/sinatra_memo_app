# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'securerandom'
require 'json'
enable :method_override

memo_dates = []

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

class Memo
  def self.write_json(memo_dates)
    File.open('db/db.json', 'w') do |file|
      file.puts(JSON.generate(memo_dates))
    end
  end

  def self.read_json
    json_dates = []
    File.open('db/db.json', 'r') do |file|
      json_dates = JSON.load(file)
    end
    json_dates = [] if json_dates.nil?
    json_dates
  end

  def self.create_memo(memo_name, memo_id, memo_text)
    {
      'memo_name' => memo_name,
      'memo_id' => memo_id,
      'memo_text' => memo_text
    }
  end

  def self.edit_memo(memo_name, memo_id, memo_text)
    {
      'memo_name' => memo_name,
      'memo_id' => memo_id,
      'memo_text' => memo_text
    }
  end
end

get '/top' do
  @title = 'top'
  @memo_dates = Memo.read_json
  erb :top
end

get '/edit_memo/:id' do
  @title = 'Edit memo'
  @memo_dates = Memo.read_json
  @memo_date = @memo_dates.find do |memo_date|
    memo_date['memo_id'] == params[:id]
  end
  erb :edit_memo
end

patch '/edit_memo/edit_run/:id' do
  @memo_dates = Memo.read_json
  @edit_before = @memo_dates.find do |memo_date|
    memo_date['memo_id'] == params[:id]
  end
  @edit_after = Memo.edit_memo(h(params[:memo_name]), params[:id], h(params[:memo_text]))
  memo_dates = @memo_dates.map { |memo_date| memo_date == @edit_before ? @edit_after : memo_date }
  Memo.write_json(memo_dates)
  redirect '/top'
end

get '/show_memo/:id' do
  @title = 'Show memo'
  @memo_dates = Memo.read_json
  @memo_date = @memo_dates.find do |memo_date|
    memo_date['memo_id'] == params[:id]
  end
  erb :show_memo
end

delete '/delete/:id' do
  @memo_dates = Memo.read_json
  @memo_dates.delete_if  do |memo_date|
    memo_date['memo_id'] == params[:id]
  end
  Memo.write_json(@memo_dates)
  redirect '/top'
end

get '/new_memo' do
  @title = 'New memo'
  erb :new_memo
end

post '/new_memo/add' do
  @memo_dates = Memo.read_json
  @memo_dates << Memo.create_memo(h(params[:memo_name]), SecureRandom.uuid, h(params[:memo_text]))
  Memo.write_json(@memo_dates)
  redirect '/top'
end
