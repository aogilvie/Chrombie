# Base
FROM debian:10.13-slim
LABEL name="chrome-headless" \
            maintainer="Ally Ogilvie <@allyogilvie>" \
            version="1.0" \
            description="Google Chrome Binary, Node.js and Puppeteer"

RUN apt-get update && apt-get install -y curl

# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && apt-get install -y nodejs

# Install deps + add Chrome Stable + purge all the things
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    --no-install-recommends \
    && curl -sSL https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update && apt-get install -y \
    google-chrome-stable \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# Install internation fonts
RUN apt-get update && apt-get install -y \
  fonts-arphic-ukai \
  fonts-arphic-uming \
  fonts-ipafont-mincho \
  fonts-ipafont-gothic \
  fonts-unfonts-core

# Add Chrome as a user
RUN groupadd --gid 1000 --system chrome && useradd --system --create-home --uid 1000 --gid chrome -G audio,video chrome

# Expose for Chrome remote debugger
EXPOSE 9222

RUN mkdir -p /app

ADD package.json /app/

WORKDIR /app

RUN chown chrome --recursive .

# Run Chrome non-privileged
USER chrome

RUN npm install

ENTRYPOINT ["node", "src/index.js"]
