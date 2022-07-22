FROM alpine
WORKDIR /opt/application/
ENV PORT=80
COPY /app/ ./
RUN apk add --update nodejs npm \
&& adduser test -D -h /opt \
&& chown -R test:test /opt/application \
&& chmod 755 /opt/application
USER test
RUN npm install
CMD npm start
