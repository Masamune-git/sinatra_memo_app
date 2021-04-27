# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'securerandom'
require 'json'
enable :method_override

memos = []

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

class Memo
  @json_path = 'db/db.json'

  def self.write_json(memos)
    File.open(@json_path, 'w') do |file|
      file.puts(JSON.generate(memos))
    end
  end

  def self.read_json
    File.open(@json_path, 'r') { |file| JSON.load(file) } || []
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
  @memos = Memo.read_json
  erb :top
end

get '/edit_memo/:id' do
  @title = 'Edit memo'
  memos = Memo.read_json
  @memo_date = memos.find do |memo_date|
    memo_date['memo_id'] == params[:id]
  end
  erb :edit_memo
end

patch '/edit_memo/edit_run/:id' do
  memos_before = Memo.read_json
  edit_before = memos.find do |memo_date|
    memo_date['memo_id'] == params[:id]
  end
  edit_after = Memo.edit_memo(params[:memo_name], params[:id], params[:memo_text])
  memos_after = memos_before.map { |memo_date| memo_date == edit_before ? edit_after : memo_date }
  Memo.write_json(memos_after)
  redirect '/top'
end

get '/show_memo/:id' do
  @title = 'Show memo'
  @memos = Memo.read_json
  @memo_date = @memos.find do |memo_date|
    memo_date['memo_id'] == params[:id]
  end
  erb :show_memo
end

delete '/delete/:id' do
  @memos = Memo.read_json
  @memos.delete_if do |memo_date|
    memo_date['memo_id'] == params[:id]
  end
  Memo.write_json(@memos)
  redirect '/top'
end

get '/new_memo' do
  @title = 'New memo'
  erb :'new_memo'
end

post '/new_memo/add' do
  @memos = Memo.read_json
  @memos << Memo.create_memo(params[:memo_name], SecureRandom.uuid, params[:memo_text])
  Memo.write_json(@memos)
  redirect '/top'
end
