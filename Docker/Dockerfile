FROM postman/newman:5.3-alpine
RUN apk update && apk upgrade && \
    npm install -g newman-reporter-csvallinone && \
    apk add curl zip iputils && \
    rm -rf /var/cache/apk/* 
ENV NODE_PATH=/usr/local/lib/node_modulesvalue 
COPY ./resolv.conf  /etc/resolv.conf
WORKDIR  /etc/newman
ENTRYPOINT ["newman"]   
