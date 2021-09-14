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
psql -f db/setup.sql postgres
```

### サーバーの起動
```
bundle exec ruby app.rb
```

### DBとテーブルを削除
DBごと完全に削除されるので注意
```
psql -f db/teardown.sql postgres
```
