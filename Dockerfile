#########################################
# Dockerfile to setup GNU Mailman Suite
# Based on Ubuntu
#########################################
# Set the base image to Ubuntu
FROM python:2.7

# File Author / Maintainer
MAINTAINER Terri Oda & Joshua Bird

# Update the sources and install some basic python stuff
RUN apt-get update
RUN apt-get install -y nginx && rsync -av /mailman3/config/ / && nginx 
RUN apt-get install -y git python3.4-dev python-dev python-pip python-virtualenv
RUN apt-get install -y ruby-full rubygems
RUN gem install sass

#RUN wget https://bootstrap.pypa.io/get-pip.py

#RUN 

# Get the nodejs stuff
RUN apt-get install -y nodejs npm && \
    npm install -g less && \
        ln -s /usr/bin/nodejs /usr/bin/node

# Set the default directory where CMD will execute
WORKDIR /mailman3

# Get Mailman Bundler
RUN git clone https://gitlab.com/mailman/mailman-bundler.git
WORKDIR /mailman3/mailman-bundler

RUN pip install zc.buildout

RUN echo 'MAILMAN_REST_API_URL="http://mailman.local:8001"' >> /mailman3/mailman-bundler/mailman_web/production.py && \
    echo 'MAILMAN_REST_API_URL="http://mailman.local:8001"' >> /mailman3/mailman-bundler/mailman_web/testing.py

# Set up virtualenv
RUN virtualenv venv
RUN . venv/bin/activate

#RUN echo "127.10.0.1    localhost   mailman.local" >> /etc/hosts


RUN buildout

# Expose ports
EXPOSE 18000
EXPOSE 8001
EXPOSE 9000
EXPOSE 9001

ENTRYPOINT \
    
    ./bin/mailman-post-update && \
    ./bin/mailman start && \
    ./bin/mailman-web-django-admin runserver 0.0.0.0:18000 
