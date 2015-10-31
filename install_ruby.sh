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
ri_RBENV_PATH="$HOME/.rbenv/bin"
echo "$ri_RBENV_PATH/rbenv init -" >> ~/.bashrc
. ~/.bashrc
$ri_RBENV_PATH/rbenv init -
if [ ! -d "$HOME/.rbenv/plugins/ruby-build" ]; then
    git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
fi 

ri_RUBY_BUILD="$HOME/.rbenv/plugins/ruby-build/bin"

echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
. ~/.bashrc
"$ri_RBENV_PATH/rbenv" install 2.2.3
"$ri_RBENV_PATH/rbenv" global 2.2.3

ruby -v
echo "gem: --no-ri --no-rdoc" > ~/.gemrc
gem install bundler
gem install rails
