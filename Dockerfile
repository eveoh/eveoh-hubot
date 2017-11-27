FROM node:8.9.1-alpine

ENV HUBOT_HOME /opt/hubot

ENV HUBOT_AUTH_ADMIN user
ENV HUBOT_IRC_SERVER irc.host.com
ENV HUBOT_IRC_ROOMS #room roompass
ENV HUBOT_IRC_PORT 6667
ENV HUBOT_IRC_UNFLOOD true
ENV HUBOT_IRC_DEBUG true
ENV HUBOT_IRC_NICKSERV_USERNAME username
ENV HUBOT_IRC_NICKSERV_PASSWORD password
ENV HUBOT_IRC_PRIVATE true

ENV HUBOT_GIPHY_API_KEY key

ENV HUBOT_SPARK_DEVICE_ID key
ENV HUBOT_SPARK_ACCESS_TOKEN key

ENV HUBOT_GITHUB_TOKEN token
ENV HUBOT_GITHUB_USER user
ENV HUBOT_GITHUB_ORG user
ENV HUBOT_GITHUB_REPO repo

ENV HUBOT_JENKINS_URL https://ci.host.com
ENV HUBOT_JENKINS_CI_USER_USERNAME user
ENV HUBOT_JENKINS_CI_USER_TOKEN token

ENV HUBOT_GOOGLE_CSE_ID id
ENV HUBOT_GOOGLE_CSE_KEY key

ENV HUBOT_GITHUB_SHARED_SECRET secret


RUN mkdir -p $HUBOT_HOME \
    && addgroup hubot \
    && adduser -h $HUBOT_HOME -D -s /bin/bash -G hubot hubot \
    && chown -R hubot:hubot $HUBOT_HOME

WORKDIR $HUBOT_HOME
USER hubot

ADD --chown=hubot:hubot ./bin $HUBOT_HOME/bin
ADD --chown=hubot:hubot ./scripts $HUBOT_HOME/scripts
ADD --chown=hubot:hubot ./*.json $HUBOT_HOME/

RUN npm install

EXPOSE 8080

ENTRYPOINT [ "sh", "-c", "/opt/hubot/bin/hubot --name eveoh --adapter irc" ]