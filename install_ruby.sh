#!/bin/sh -ex

#Root check 
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root." 1>&2
    exit 1
fi

if [ -f /etc/debian_version ]; then
    ri_OS=Debian
    ri_OS_VER=$(cat /etc/debian_version)
fi
echo $ri_OS

if [ "$ri_OS" = "Debian" ]; then
    apt-get update
    apt-get -y install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev
fi

cd
if [ ! -d ".rbenv" ]; then
    git clone git://github.com/sstephenson/rbenv.git .rbenv
fi
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
. ~/.bashrc

if [ ! -d "~/.rbenv/plugins/ruby-build" ]; then
    git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
fi 

echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
. ~/.bashrc
rbenv install 2.2.3
rbenv global 2.2.3

ruby -v
echo "gem: --no-ri --no-rdoc" > ~/.gemrc
gem install bundler
gem install rails
