
FROM ubuntu:latest

# install libs, xvfb and other libraries
RUN apt-get update && apt-get install -y zlib1g-dev xvfb libxcomposite1 libasound2 libdbus-glib-1-2 libgtk2.0-0 && apt-get install -y wget && apt-get install -y ruby-dev
RUN apt-get install -y make
RUN apt-get install -y build-essential
RUN apt-get install -y nginx
RUN apt-get install -y curl
RUN apt-get install -y libxml2-dev
RUN apt-get install -y libxslt-dev
RUN ruby -v
RUN gcc -v

# Install chrome
RUN curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add \
    && echo "deb [arch=amd64]  http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list\
    && apt-get -y update\
    && apt-get -y install google-chrome-stable

# Install chrome driver
RUN wget https://chromedriver.storage.googleapis.com/2.41/chromedriver_linux64.zip \
    && unzip chromedriver_linux64.zip
RUN mv chromedriver /usr/bin/chromedriver \
    && chown root:root /usr/bin/chromedriver \
    && chmod +x /usr/bin/chromedriver

# Copy the files over
RUN mkdir /app \
    && mkdir /app/scraper
WORKDIR /app/scraper
COPY . /app/scraper


# Install ruby gems
RUN gem install bundler
RUN gem install pkg-config
RUN gem install nokogiri -- --use-system-libraries
RUN bundle install

# Set ENV variables
ENV PORT = $PORT

# Commands to run on container run
CMD rackup
