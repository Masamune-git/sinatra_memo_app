## 概要

このリポジトリは FjordBootCamp の Web アプリケーション プラクティスの提出物です。  
Sinatra を利用したメモアプリになります。作成したメモは `sina_memo/db`配下に json ファイルとして保存されます。

## セットアップ

Sinatra をインストールしてください。

```shell
gem install sinatra
gem install sinatra-contrib
```

次に gem をインストールしてください。

```shell
bundle install
```

以下でサーバーを立ち上げます。

```shell
ruby main.rb
```

http://localhost:4567/top にアクセスできれば、セットアップ完了です。
