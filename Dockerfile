FROM node:0.10

RUN apt-get update && \
    apt-get install -y unzip

RUN mkdir -p /usr/src/app && \
    wget -O /tmp/ghost-latest.zip https://ghost.org/zip/ghost-latest.zip && \
    unzip /tmp/ghost-latest.zip -d /usr/src/app && \
    rm /tmp/ghost-latest.zip && \
    useradd ghost --home /usr/src/app

WORKDIR /usr/src/app
RUN npm install --production

ENV NODE_ENV production
ENV BLOG_URL http://my-ghost-blog.com

COPY config.js usr/src/app/config.js
RUN chown ghost:ghost -R /usr/src/app
USER ghost

VOLUME ["/usr/src/app/content/images", "/usr/src/app/content/data"]
EXPOSE 2368
CMD [ "npm", "start" ]

ONBUILD COPY apps   /usr/src/app/content/apps/
ONBUILD COPY themes /usr/src/app/content/themes/
#RUN chown ghost:ghost -R /usr/src/app
