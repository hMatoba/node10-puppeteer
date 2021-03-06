FROM node:10-alpine

# Installs latest Chromium (68) package.
RUN apk update && apk upgrade && \
    echo @edge http://nl.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories && \
    echo @edge http://nl.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories && \
    apk add --no-cache \
      chromium@edge \
      nss@edge \
      harfbuzz@edge
ENV DOCKERIZE_VERSION v0.6.0
RUN apk add --no-cache openssl \
 && wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
 && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
 && rm dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz
 
# Tell Puppeteer to skip installing Chrome. We'll be using the installed package.
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true
ENV CHROME_BIN /usr/bin/chromium-browser

# Puppeteer v1.4.0 works with Chromium 68.
RUN npm install -g --unsafe-perm puppeteer@1.9.0

# Add user so we don't need --no-sandbox.	
RUN addgroup -S pptruser && adduser -S -g pptruser pptruser \	
    && mkdir -p /home/pptruser/Downloads \	
    && mkdir -p /app \	
    && chown -R pptruser:pptruser /home/pptruser \	
    && chown -R pptruser:pptruser /app	

 # Run everything after as non-privileged user.	
USER pptruser	

CMD ["/bin/ash"]
