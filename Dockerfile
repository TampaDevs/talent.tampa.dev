FROM ruby:3.2.2

RUN set -xe \
    && apt update && apt -y upgrade

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN echo "America/New_York" > /etc/timezone 
ENV DEBIAN_FRONTEND=noninteractive

# Install Base Dependencies 
RUN set -xe \
    && apt -y install --no-install-recommends curl gnupg2 

# Install Stripe CLI
RUN set -xe \
    && curl -s https://packages.stripe.dev/api/security/keypair/stripe-cli-gpg/public | gpg --dearmor |  tee /usr/share/keyrings/stripe.gpg >/dev/null \ 
    && echo "deb [signed-by=/usr/share/keyrings/stripe.gpg] https://packages.stripe.dev/stripe-cli-debian-local stable main" |  tee -a /etc/apt/sources.list.d/stripe.list \
    && apt update \ 
    && apt -y install --no-install-recommends stripe

# Install Google Chrome
RUN set -xe \
    && apt update \
    && apt -y install --no-install-recommends socat \
    && apt -y install --no-install-recommends xvfb x11vnc fluxbox xterm \
    && apt -y install --no-install-recommends sudo 

RUN set -xe \
    && curl -s https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor | tee /usr/share/keyrings/google.gpg >/dev/null \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google.gpg] http://dl.google.com/linux/chrome/deb/ stable main" | tee -a /etc/apt/sources.list.d/google.list \
    && apt update \
    && apt -y install --no-install-recommends google-chrome-stable

# Create a User
RUN set -xe \
    && useradd -u 1000 -g 100 -G sudo --shell /bin/bash --no-create-home --home-dir /tmp user \
    && echo 'ALL ALL = (ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers

# Install NodeJS
RUN set -xe \ 
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt -y install --no-install-recommends nodejs

# Install Yarn
RUN set -xe \
    && npm install --global yarn

# Install Application Dependencies
RUN set -xe \ 
    && apt -y install --no-install-recommends libpq-dev imagemagick libvips-dev libvips-tools libvips42 chromium-driver

# TEMPORARY: Install Redis & Postgres 
RUN set -xe \ 
    && apt -y install --no-install-recommends postgresql redis

RUN set -xe \ 
    && rm -rf /var/lib/apt/lists/*

COPY . /app

# Install Application Gems and Yarn Packages
RUN set -xe \
    && cd /app \
    && gem install bundler --conservative \ 
    && bundle check || bundle install \ 
    && yarn install \
    && gem install foreman