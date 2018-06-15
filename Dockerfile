#
# Scala and sbt Dockerfile
#
# https://github.com/prizeGit/scala-sbt
#

# Pull base image
FROM openjdk:8u162

# Env variables
ENV SCALA_VERSION 2.11.1
ENV SBT_VERSION 1.1.2

# Scala expects this file
RUN touch /usr/lib/jvm/java-8-openjdk-amd64/release

# Install Scala
## Piping curl directly in tar
RUN \
  curl -fsL https://downloads.typesafe.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz | tar xfz - -C /root/ && \
  echo >> /root/.bashrc && \
  echo "export PATH=~/scala-$SCALA_VERSION/bin:$PATH" >> /root/.bashrc

# Install sbt
RUN \
  curl -L -o sbt-$SBT_VERSION.deb https://dl.bintray.com/sbt/debian/sbt-$SBT_VERSION.deb && \
  dpkg -i sbt-$SBT_VERSION.deb && \
  rm sbt-$SBT_VERSION.deb && \
  apt-get update && \
  apt-get install sbt && \
  sbt sbtVersion

# Install aws cli
RUN wget "https://bootstrap.pypa.io/get-pip.py" -O /tmp/get-pip.py \
    && python /tmp/get-pip.py \
    && pip install awscli==1.11.25 \
    && rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/* 

# Install node
RUN \
  curl -sL https://deb.nodesource.com/setup_10.x | bash - \
  && apt-get install -y nodejs  \
  && npm install -g @angular/cli

# Define working directory
WORKDIR /root
