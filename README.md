# sinatra-memo-app

## 使い方

`sinatra-memo-app`ディレクトリ配下で以下のコマンドを実行

### 実行に必要な gem のインストール
```
bundle install
```

### DBとテーブルを作成
ローカルに必要なDBとテーブルを作成する
```
psql -f db/setup_app_db.sql postgres
```

### サーバーの起動
```
bundle exec ruby app.rb production
```

### テストの実行
```
./run_test.sh
```
