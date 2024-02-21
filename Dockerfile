###################################################
# Dokerfileは単独のDockerイメージを作る時の設定ファイル
# 自分の好きなようにカスタマイズしたDocker Imageを作成可能
###################################################
# 元となるDockerイメージFROMをDocker HUBから指定 2024/2 最新3.2.2
# Rails6まではnodeのインストールが必要だったがRails７からは不要になった
FROM --platform=linux/arm64 ruby:3.1.4
# Dockerfile内で使える変数
ARG RUBYGEMS_VERSION=3.3.20
# Linuxの不要なファイル群を削除するおまじないコマンド
RUN apt-get update -qq && \
    apt-get install -y build-essential libvips && \
    file\
    imagemagick\
    git\
    tzdata\
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man
# コマンド実行　ディレクトリ作成
RUN mkdir /app
# 作業ディレクトリの指定
WORKDIR /app
# ローカルファイルをコンテナの中にコピー Gemは最初から必要なファイルのためコンテナにコピーしている
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
# コマンド実行　Gemアップデート後にバンドルインストール
RUN gem update --system ${RUBYGEMS_VERSION} && bundle install
COPY . /app
# メモ書きです。EXPOSE自体に意味はないがエンジニアにポートを伝える役割がある
EXPOSE 8001
# 起動スクリプト設定 データベースの作成などに必要です
COPY entrypoint.sh /usr/bin/
# entrypoint.shの実行権限を付与
RUN chmod +x /usr/bin/entrypoint.sh
# コンテナ起動時にentrypoint.shを実行するように設定
# 本来は指定したいが"entrypoint.sh: exec format error"になるため除外
# ENTRYPOINT ["entrypoint.sh"]
# イメージに含まれるソフトウェアの実行 下記はRailsサーバーを起動しています
CMD ["rails", "server", "-b", "0.0.0.0"]
