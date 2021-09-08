FROM jupyter/base-notebook

USER root

RUN apt-get update -y && \
    apt-get install -y  build-essential patch libtool libffi-dev ruby ruby-dev make
RUN apt-get install -y libzmq3-dev libczmq-dev libsqlite3-dev zlib1g-dev liblzma-dev

RUN gem install cztop iruby
RUN iruby register --force

RUN gem install pco_api sqlite3 google-api-client zlib nokogiri

RUN pip install numpy

RUN sudo chown -R $NB_UID:$NB_GID ~/.local/share/jupyter 

USER $NB_UID
