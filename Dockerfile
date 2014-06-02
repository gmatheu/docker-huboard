FROM ubuntu:14.04
MAINTAINER Gonzalo Matheu <gonzalommj@gmail.com>

# Run upgrades
RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get -y install squid-deb-proxy-client

# Install basic packages
RUN apt-get -y install git curl build-essential vim

# Install Ruby 2.0
RUN apt-get -qq -y install python-software-properties
# RUN apt-add-repository ppa:brightbox/ruby-ng
RUN echo "deb http://ppa.launchpad.net/brightbox/ruby-ng/ubuntu trusty main" >> /etc/apt/sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F5DA5F09C3173AA6 
RUN apt-get update
RUN apt-get -y install ruby2.1 ruby2.1-dev
RUN gem install bundler --no-ri --no-rdoc

# Install packages for installing Huboard 
RUN apt-get -y install couchdb memcached 
RUN gem install foreman
RUN apt-get -y install libssl-dev

# Install Node.js
RUN echo "deb http://ppa.launchpad.net/chris-lea/node.js/ubuntu trusty main" >> /etc/apt/sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B9316A7BC7917B12 
RUN apt-get update
RUN apt-get -y install python g++ make nodejs
RUN npm install -g couchapp

RUN apt-get clean

# Install Huboard
RUN git clone -b master https://github.com/rauhryan/huboard.git /app
RUN sed -i s/2.0.0/2.1.1/g /app/Gemfile
RUN cd /app; bundle install;

ADD Procfile /app/Procfile
ADD bootstrap.sh /app/bootstrap.sh
ADD env /app/.env

# Run Huboard instance
EXPOSE 5000
CMD sh /app/bootstrap.sh
