#!/bin/sh

[ "$APP_DEBUG" = 'true' ] && set -x
set -e

if [ "$APP_DEBUG" = 'true' ]; then
  echo "> You will act as user: $(id -u -n)"
  echo "> Your project source directory: $(pwd)"
  ls -al
fi

if [ "$#" -eq 0 ]; then
  set -- .
fi

exec php /usr/local/bin/pack_zba.php "$@"
