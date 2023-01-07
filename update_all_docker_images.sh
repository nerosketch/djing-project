#!/bin/bash

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin

which docker
if [ $? -eq 1 ]; then
  echo "docker not found. Check if it is installed."
  exit 1
fi

set -e

upd() {
  cd "$1"
  git checkout "$2"
  git pull origin "$2"
  cd ..
}

git pull
git submodule init
git submodule update
upd djing-lk master
upd djing2 devel
upd djing2-elui devel
upd nginx master
upd pgbouncer master
upd ws master

./generate_secrets.sh

upd_release() {
  cd "$1"
  ./update_release.sh
  cd ..
}
upd_release djing-lk
upd_release djing2
upd_release djing2-elui
upd_release nginx
upd_release pgbouncer
upd_release ws