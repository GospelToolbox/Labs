#!/usr/bin/env sh

# $0 is a script name,
# $1, $2, $3 etc are passed arguments
# $1 is our command
CMD=$1

case "$CMD" in
  'start' )
    echo `pwd`
    rm -f /data/src/tmp/pids/server.pid
    rails s -b 0.0.0.0
    ;;

  'bootstrap' )
    bundle exec rails db:create db:migrate
    ;;

   * )

    exec "$@"
    ;;
esac
