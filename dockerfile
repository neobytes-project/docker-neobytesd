# Use the latest available Ubuntu image as build stage
FROM ubuntu:bionic AS builder

#Add ppa:bitcoin/bitcoin repository so we can install libdb4.8 libdb4.8++
RUN apt-get update && \
	apt-get install -y software-properties-common && \
	add-apt-repository ppa:bitcoin/bitcoin

#Install build dependencies
RUN apt-get update && \
  apt-get upgrade -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
	bash build-essential libtool autotools-dev automake git wget\
	pkg-config libssl-dev libevent-dev bsdmainutils python3 \
	libboost-system-dev libboost-filesystem-dev libboost-chrono-dev \
	libboost-program-options-dev libboost-test-dev libboost-thread-dev \
	libzmq3-dev libminiupnpc-dev libdb4.8-dev libdb4.8++-dev && \
	apt-get clean

# Set variables necessary for download and verification of neobytesd
ARG VERSION=0.12.1.1
ENV NEOBYTES_DATA=/neobytes/.neobytes
ENV PATH=/opt/neobytes-${VERSION}/bin:$PATH

# Download Neobytes repository
RUN set -ex \
  && wget -q --show-progress --progress=dot:giga https://gitea.sikkiesnet.nl/neobytes-project/neobytes/releases/download/v${VERSION}/neobytes-${VERSION}-linux64.tar.gz \
  && tar -xzvf neobytes-${VERSION}-linux64.tar.gz -C /opt \
  && ln -sv neobytes-${VERSION} /opt/neobytes \
  && rm *.tar.gz \
  && rm -rf /opt/neobytes-${VERSION}/bin/neobytes-qt

# Use latest Ubuntu image as base for main image
FROM ubuntu:bionic AS final
LABEL maintainer="SikkieNL (@sikkienl)"

WORKDIR /neobytes

# Set neobytes user and group with static IDs
ARG GROUP_ID=1000
ARG USER_ID=1000
RUN groupadd -g ${GROUP_ID} neobytes \
   && useradd -u ${USER_ID} -g neobytes -d /neobytes neobytes

# Copy over neobytes binaries
COPY --chown=neobytes:neobytes --from=builder /opt/neobytes/bin/ /usr/local/bin/

# Upgrade all packages and install dependencies
RUN apt-get update \
  && apt-get upgrade -y
RUN DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends gosu \
  && apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Copy scripts to Docker image
COPY ./bin ./docker-entrypoint.sh /usr/local/bin/

VOLUME ["/neobytes/.neobytes"]

# Set HOME
ENV HOME=/neobytes

EXPOSE 1427 1428 11427 11428 11444

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

CMD ["nby_oneshot"]