FROM jupyter/base-notebook

USER root

RUN apt-get update -y && \
    apt install -y libtool libffi-dev ruby ruby-dev make
RUN apt install -y libzmq3-dev libczmq-dev libsqlite3-dev

RUN gem install cztop iruby
RUN iruby register --force

RUN gem install pco_api sqlite3 google-api-client

RUN pip install numpy

USER $NB_UID
