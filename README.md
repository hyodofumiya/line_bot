# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

# 勤怠管理アプリケーション
LINE上で簡単に勤怠管理ができるアプリケーションです。

* * * 

# 概要
ポートフォリオとして作成したアプリケーションです。このアプリは、LINE上で勤怠管理ができるアプリケーションです。
#### 全てのユーザーは、LINE画面上で以下を実行できます。
- ワンアクションで勤怠入力
- ユーザー登録
- 勤怠履歴の閲覧・修正
- 管理者からの連絡を受け取る
#### 管理者は、web上で以下を実行できます。
- 社員情報と勤怠情報を閲覧・新規作成・修正
- 社員または勤怠のレコードにメンション付きのLINEメッセージを送信
#### 管理者以外は、web上で以下を実行できます。
- 自身の勤怠履歴を管理
- LINEアカウントのみでログイン

# デモ

# 使用言語、環境
- 言語
  Ruby version '2.5.1'
- フレームワーク
  Ruby on Rails version '5.2.4'
- DB
  postgresql
- 本番サーバー
  heroku
# 機能一覧

# 今後の計画
- ユーザー同士の報連相機能を追加する
- HerokuサーバーをAWSに移行する