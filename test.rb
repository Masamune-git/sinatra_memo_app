# frozen_string_literal: true
#!/opt/local/bin/ruby

require "rubygems"
require 'pg'

# データベース接続する（不要なものは指定しなくても良い。:port は標準で 5432 が使用される模様）
@connection = PG.connect(:host => 'localhost', :user => 'masamene',  :dbname => 'memo_date', :port => 5432)
begin
  # connection を使い PostgreSQL を操作する
  query = 'INSERT INTO memo_date (id, memo_name, memo_text) VALUES VALUES ($1, $2, $3);'
  @connection.exec(query,['key1', 'key2', 'key3'])
ensure
  # データベースへのコネクションを切断する
  @connection.finish
end
