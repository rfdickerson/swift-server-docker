FROM ubuntu:16.04
MAINTAINER Robert F. Dickerson <rfdickerson@gmail.com>
LABEL description="builds stuff"

ENV HOME /root
ENV WORK_DIR /root

WORKDIR /root

RUN apt-get update && apt-get install -y \
  build-essential \
  clang \
  git \
  libicu-dev \
  wget \
  libcurl4-openssl-dev \
  libxml2 \
  sudo \
  curl

# NOTE: Eventually change to 16.04 once snapshots exist for it
# # ENV PLATFORM ubuntu16.04
ENV PLATFORM ubuntu15.10
#
RUN git clone https://github.com/kylef/swiftenv.git ~/.swiftenv
ENV SWIFTENV_ROOT $WORK_DIR/.swiftenv
ENV PATH $SWIFTENV_ROOT/bin:$PATH

RUN swiftenv install 3.0
RUN swiftenv install 3.0.1

COPY /build-swift-project.sh /
ENTRYPOINT ["/build-swift-project.sh"]

