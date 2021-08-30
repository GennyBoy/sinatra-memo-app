# sinatra-memo-app

## 使い方

`sinatra-memo-app`ディレクトリ配下で以下のコマンドを実行

### 実行に必要な gem のインストール
```
bundle install
```

### memosテーブルの作成
ローカルにあるDBにmemosテーブルを作成する
```
psql -f db/setup_memos_table.sql db_name
```

### サーバーの起動
```
bundle exec ruby app.rb
```
