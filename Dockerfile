FROM curlimages/curl:7.69.1
USER root

RUN addgroup -S script && adduser -S -G script script

RUN apk update
RUN apk upgrade
RUN apk add bash

USER script

WORKDIR /scripts

COPY . .

CMD ["bash", "notify.sh"]