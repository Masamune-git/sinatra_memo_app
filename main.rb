# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'securerandom'
require 'pg'
enable :method_override

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

class Memo
  def self.prepare_db
    return if @connection

    @connection = PG.connect(host: 'localhost', user: 'postgres', dbname: 'memos', port: 5432)
    @connection.prepare('read_db', 'SELECT * FROM memos;')
    @connection.prepare('create_memo', 'INSERT INTO memos (memo_id, memo_name, memo_text) VALUES ($1, $2, $3);')
    @connection.prepare('edit_memo', 'UPDATE memos SET memo_name = $1, memo_text = $2 WHERE memo_id = $3;')
    @connection.prepare('delete_memo', 'DELETE FROM memos WHERE memo_id = $1;')
  end

  def self.read_db
    @connection.exec_prepared('read_db')
  end

  def self.create_memo(memo_name, memo_id, memo_text)
    @connection.exec_prepared('create_memo', [memo_id, memo_name, memo_text])
  end

  def self.edit_memo(memo_name, memo_id, memo_text)
    @connection.exec_prepared('edit_memo', [memo_name, memo_text, memo_id])
  end

  def self.delete_memo(memo_id)
    @connection.exec_prepared('delete_memo', [memo_id])
  end
end

before do
  Memo.prepare_db
end

get '/memos' do
  @title = 'top'
  @memos = Memo.read_db
  erb :top
end
# ok

get '/memos/create_memo' do
  @title = 'New memo'
  erb :new_memo
end
# ok

get '/memos/:id/edit' do
  @title = 'Edit memo'
  memos = Memo.read_db
  @memo_date = memos.find do |memo_date|
    memo_date['memo_id'] == params[:id]
  end
  erb :edit_memo
end
# ok

patch '/memos/:id' do
  Memo.edit_memo(params[:memo_name], params[:id], params[:memo_text])
  redirect '/memos'
end
# ok

get '/memos/:id' do
  @title = 'Show memo'
  memos = Memo.read_db
  @memo_date = memos.find do |memo_date|
    memo_date['memo_id'] == params[:id]
  end
  erb :show_memo
end
# ok

delete '/memos/:id' do
  Memo.delete_memo(params[:id])
  redirect '/memos'
end
# ok

post '/memos' do
  Memo.create_memo(params[:memo_name], SecureRandom.uuid, params[:memo_text])
  redirect '/memos'
end
# ok
