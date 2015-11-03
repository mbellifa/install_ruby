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

if [ -f /etc/redhat-release ]; then
    ri_OS=Redhat
    ri_OS_VER=$(cat /etc/redhat-release)
fi
#echo $ri_OS

if [ "$ri_OS" = "Debian" ]; then
    apt-get update
    apt-get -y install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev 
fi
if [ "$ri_OS" = "Redhat" ]; then
    yum -y install git-core curl make automake gcc gcc-c++ kernel-devel zlib-devel openssl-libs readline-devel libyaml-devel sqlite-devel sqlite  libxml2-devel libxslt-devel libcurl-devel libffi-devel openssl-devel patch
fi
cd
if [ ! -d ".rbenv" ]; then
    git clone git://github.com/sstephenson/rbenv.git .rbenv
fi

if ! grep -Fq ".rbenv/bin:" ~/.bashrc
then
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
fi

ri_RBENV_PATH="$HOME/.rbenv/bin"

if ! grep -Fq "rbenv init -" ~/.bashrc
then
    echo 'eval "$($HOME/.rbenv/bin/rbenv init -)"' >> ~/.bashrc
fi
. ~/.bashrc
if [ ! -d "$HOME/.rbenv/plugins/ruby-build" ]; then
    git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
fi 

ri_RUBY_BUILD="$HOME/.rbenv/plugins/ruby-build/bin"
if ! grep -Fq ".rbenv/plugins/ruby-build/bin" ~/.bashrc
then
    echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
fi
. ~/.bashrc
"$ri_RBENV_PATH/rbenv" install 2.2.3
"$ri_RBENV_PATH/rbenv" global 2.2.3
ri_RBENV_SHIMS="$HOME/.rbenv/shims"
"$ri_RBENV_SHIMS/ruby" -v

echo "gem: --no-ri --no-rdoc" > ~/.gemrc
"$ri_RBENV_SHIMS/gem" install bundler
"$ri_RBENV_SHIMS/gem" install rails
exec $SHELL
