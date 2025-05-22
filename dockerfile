# Use the latest available Ubuntu image as build stage
#FROM ubuntu:bionic AS builder
FROM ubuntu:bionic

#Add ppa:bitcoin/bitcoin repository so we can install libdb4.8 libdb4.8++
RUN apt-get update && \
	apt-get install -y software-properties-common && \
	add-apt-repository ppa:bitcoin/bitcoin

#Install build dependencies
RUN apt-get update && \
  apt-get upgrade -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
	bash git wget python3\
  build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils \
	libboost-system-dev libboost-filesystem-dev libboost-chrono-dev \
	libboost-program-options-dev libboost-test-dev libboost-thread-dev \
	libminiupnpc-dev libzmq3-dev libdb4.8-dev libdb4.8++-dev && \
	apt-get clean

# Set variables necessary for download and verification of neobytesd
ARG VERSION=0.12.1.3
ENV NEOBYTES_DATA=/neobytes/.neobytes
ENV PATH=/opt/neobytes-${VERSION}/bin:$PATH

# Download Neobytes repository
RUN set -ex \
  && wget -q --show-progress --progress=dot:giga https://github.com/neobytes-project/neobytes/releases/download/v${VERSION}/neobytes-${VERSION}-linux64.tar.gz \
  && tar -xzvf neobytes-${VERSION}-linux64.tar.gz -C /opt \
  && ln -sv neobytes-${VERSION} /opt/neobytes \
  && rm *.tar.gz \
  && rm -rf /opt/neobytes-${VERSION}/bin/neobytes-qt

# Use latest Ubuntu image as base for main image
#FROM ubuntu:bionic

LABEL author="Kyle Manna <kyle@kylemanna.com>" \
      maintainer="SikkieNL (@sikkienl)"

WORKDIR /neobytes

# Set neobytes user and group with static IDs
ARG GROUP_ID=1000
ARG USER_ID=1000
RUN groupadd -g ${GROUP_ID} neobytes \
   && useradd -u ${USER_ID} -g neobytes -d /neobytes neobytes

# Upgrade all packages and install dependencies
RUN apt update \
  && apt install -y --no-install-recommends gosu libatomic1 \
  && apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && ln -sv /opt/neobytes/bin/* /usr/local/bin

# Copy scripts to Docker image
COPY ./bin ./docker-entrypoint.sh /usr/local/bin/
RUN chmod a+x /usr/local/bin/*

# Enable entrypoint script
ENTRYPOINT ["docker-entrypoint.sh"]

# Set HOME
ENV HOME=/neobytes

# Expose default p2p and RPC ports
EXPOSE 1427 1428 11427 11428 11444 21427

# Expose default neobytesd storage location
VOLUME ["/neobytes/.neobytes"]

CMD ["nby_oneshot"]