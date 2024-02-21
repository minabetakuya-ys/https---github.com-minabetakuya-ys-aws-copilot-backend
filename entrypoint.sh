########################################################
#コンテナ起動時に実行するスクリプトを記述するためのファイル
#前回のRailsサーバの終了が不完全だった場合、server.pidというファイルが残ってしまい、
#それが原因で新しいサーバの起動に失敗することがあります。この問題を防ぐために、サーバ起動前にこのファイルを削除
########################################################
#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /app/tmp/pids/server.pid

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
