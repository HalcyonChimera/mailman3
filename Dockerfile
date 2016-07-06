#########################################
# Dockerfile to setup GNU Mailman Suite
#########################################

FROM python:2.7

# File Author / Maintainer
MAINTAINER Joshua Bird

RUN apt-get update
RUN apt-get install -y nginx

RUN curl https://raw.githubusercontent.com/HalcyonChimera/mailman3/master/config/etc/nginx/sites-enabled/default > /etc/nginx/sites-enabled/default

RUN apt-get install -y rsync bash
RUN apt-get install -y vim
RUN apt-get install -y git python3.4-dev python-dev python-pip python-virtualenv
RUN apt-get install -y nodejs npm && \
    npm install -g less && \
        ln -s /usr/bin/nodejs /usr/bin/node
RUN apt-get install -y ruby-full rubygems
RUN gem install sass

# get mailman-bundler
WORKDIR /mailman3
RUN git clone https://gitlab.com/mailman/mailman-bundler.git
RUN pip install zc.buildout
WORKDIR /mailman3/mailman-bundler


RUN buildout
RUN virtualenv venv
RUN . venv/bin/activate
RUN curl https://raw.githubusercontent.com/HalcyonChimera/mailman3/master/config/mailman3/mailman-bundler/venv-3.4/lib/python3.4/site-packages/mailman/config/schema.cfg > /mailman3/mailman-bundler/venv-3.4/lib/python3.4/site-packages/mailman/config/schema.cfg

RUN echo 'MAILMAN_REST_API_URL="http://mailman.local:8001"' >> /mailman3/mailman-bundler/mailman_web/production.py && \
    echo 'MAILMAN_REST_API_URL="http://mailman.local:8001"' >> /mailman3/mailman-bundler/mailman_web/testing.py

# Expose ports
EXPOSE 18000
EXPOSE 8001

ENTRYPOINT /mailman3/scripts/run
