FROM ubuntu

ENV HUBOT_DEFAULT_STATION=STP

RUN apt-get update
RUN apt-get -y install expect redis-server nodejs npm

RUN apt-get update && \
    apt-get install -y python-pip && \
    pip install awscli

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/bin/nodejs /usr/bin/node

RUN npm install -g coffee-script
RUN npm install -g yo generator-hubot

# Create hubot user
RUN	useradd -d /hubot -m -s /bin/bash -U hubot

# Log in as hubot user and change directory
USER	hubot
WORKDIR /hubot

# Install hubot
RUN yo hubot --owner="Chris <cw@localz.co>" --name="lubot" --description="Did someone say unicorns?" --defaults

# Some adapters / scripts
RUN npm install hubot-slack --save && npm install
RUN npm install hubot-google-translate --save && npm install
RUN npm install hubot-github --save && npm install
RUN npm install hubot-alias --save && npm install
RUN npm install hubot-youtube --save && npm install
RUN npm install hubot-s3-brain --save && npm install
RUN npm install hubot-business-cat --save && npm install
RUN npm install hubot-victory --save && npm install
RUN npm install hubot-nationalrail --save && npm install

# Activate some built-in scripts
#ADD hubot-scripts.json /hubot/
ADD hubot/external-scripts.json /hubot/
ADD hubot/scripts/ackbar.coffee /hubot/scripts/
ADD hubot/scripts/fuck_yeah_nouns.coffee /hubot/scripts/
ADD hubot/scripts/meme_generator.coffee /hubot/scripts/

EXPOSE 8080

CMD bin/hubot -a slack
