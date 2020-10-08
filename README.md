# 勤怠管理アプリケーション
ポートフォリオとして作成したアプリケーションです。このアプリは、LINE上で勤怠管理ができるアプリケーションです。

* * * 
<br>

# 概要
このアプリは、手軽に勤怠管理ができるアプリケーションです。
##### 全てのユーザーは、LINE画面上で以下を実行できます。
- ワンアクションで勤怠入力
- ユーザー登録
- 勤怠履歴の閲覧・修正
- 管理者からの連絡を受け取る
##### 管理者ユーザーでは、web上で以下を実行できます。
- 社員情報と勤怠情報を閲覧・新規作成・修正
- 社員または勤怠のレコードにメンション付きのLINEメッセージを送信
##### 管理者以外のユーザーでは、web上で以下を実行できます。
- 自身の勤怠履歴を管理
- LINEアカウントのみでログイン
<br>

# デモ
![LINE上の操作](public/line勤怠デモ.gif "勤怠操作画面")
![管理者の操作](public/管理者操作デモ.gif "管理者操作画面")
<br>

# 実装機能
## ユーザー関連
- 管理者権限機能
- 登録機能(LINE上で操作)
- 修正機能(管理者のみ操作可能)
- LINEにメッセージを送信する機能
## 勤怠簿関連
  - LINE上で操作
    - 新規登録
    - 一覧表示機能
    - 詳細表示機能
    - 修正機能
  - ブラウザ上で操作
    - LINEログイン機能
    - 新規登録機能
    - 一覧表示機能
    - 詳細表示機能
    - LINEにメッセージ送信機能
    - 修正機能
    - 検索機能
    - 並び替え機能
## その他
  - Rspecによる簡易的なテストの実行
<br>

# 使用言語、環境
- 言語  
  Ruby version 2.5.1
- フレームワーク  
  Ruby on Rails version 5.2.4
- DB  
  postgresql
- サーバー  
  heroku
<br>

# 使い方
- 管理者ユーザー以外の使い方
  1. LINEのアカウント検索機能で「@2140dd0s」と検索し、「勤怠管理アプリ」を友達追加する
  1. ユーザー登録を指示されるので、指示に従い登録する（セイ、メイは任意の偽名を、社員番号は連番以外の５ケタを入力してください。）
  - LINE上で操作する場合  
    ユーザー登録完了後はリッチメニューのボタンから各操作が可能となります。(報連相機能はお使い頂けません。)
  - ブラウザ上で操作する場合  
    下記リンクからLINEログインを行っていただくと各操作が可能となります。    
    [社員ログイン](https://protected-mesa-60860.herokuapp.com/user_session/login)
- 管理者ユーザーの使い方
  1. 下記リンクからサンプルアプリの管理者用ログインページに移動してください   
    [管理者ログイン](https://protected-mesa-60860.herokuapp.com/users/sign_in)
  1. ログイン画面に   
    email: "sample@sample.com"   
    password: "samplepass"  
    と入力してログインしてください  
  1. ログイン後は各機能が操作可能です。

  **仕様上、他の方がテストした際にメッセージが届く可能性があります。お手数ですが、テスト後に管理者ユーザーで自身のユーザーを削除してください。**


# 今後の計画
- ユーザー同士の報連相機能を追加する
- HerokuサーバーをAWSに移行する