FROM ruby:2.7.2

RUN apt-get update && apt-get install -y \
    apt-transport-https \
    curl

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq \
    software-properties-common && \
    curl -sL https://deb.nodesource.com/setup_14.x | sh -

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

    
RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq \
    build-essential \
    libpq-dev \
    zlib1g-dev \
    unattended-upgrades \
    git \
    tzdata \
    nodejs && \
    apt remove -y cmdtest && \
    apt update -y && \
    apt install -y yarn
 
RUN gem install bundler

RUN mkdir -p /src/gospeltoolbox/labs
WORKDIR /src/gospeltoolbox/labs

COPY Gemfile /src/gospeltoolbox/labs/Gemfile
COPY Gemfile.lock /src/gospeltoolbox/labs/Gemfile.lock

# Planning Center Engine
COPY engines/pco/Gemfile /src/gospeltoolbox/labs/engines/pco/Gemfile
COPY engines/pco/pco.gemspec /src/gospeltoolbox/labs/engines/pco/pco.gemspec
COPY engines/pco/lib/pco/version.rb /src/gospeltoolbox/labs/engines/pco/lib/pco/version.rb

# Set Planner engine
COPY engines/set_planner/Gemfile /src/gospeltoolbox/labs/engines/set_planner/Gemfile
COPY engines/set_planner/set_planner.gemspec /src/gospeltoolbox/labs/engines/set_planner/set_planner.gemspec
COPY engines/set_planner/lib/set_planner/version.rb /src/gospeltoolbox/labs/engines/set_planner/lib/set_planner/version.rb

# Set Live engine
COPY engines/set_live/Gemfile /src/gospeltoolbox/labs/engines/set_live/Gemfile
COPY engines/set_live/set_live.gemspec /src/gospeltoolbox/labs/engines/set_live/set_live.gemspec
COPY engines/set_live/lib/set_live/version.rb /src/gospeltoolbox/labs/engines/set_live/lib/set_live/version.rb

RUN bundle install

COPY package.json /src/gospeltoolbox/labs/package.json
COPY yarn.lock /src/gospeltoolbox/labs/yarn.lock
RUN yarn install

COPY . /src/gospeltoolbox/labs

ENV PORT 80
EXPOSE 80

ENTRYPOINT ["./docker/entrypoint.sh"]
CMD ["start"]
