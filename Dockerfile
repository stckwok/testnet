# bitcoin-testnet-box docker image

# Ubuntu 16.04 LTS (Xenial Xerus)
FROM ubuntu:16.04
MAINTAINER S Kwok <stckwok@hotmail.com>

# add bitcoind from the official PPA
RUN apt-get update
RUN apt-get install --yes software-properties-common
RUN add-apt-repository --yes ppa:bitcoin/bitcoin
RUN apt-get update

# install bitcoind (from PPA) and make
RUN apt-get install --yes bitcoind make

# create a non-root user
RUN adduser --disabled-login --gecos "" bchtester

# run following commands from user's home directory
#WORKDIR /home/bchtester

# copy the testnet-box files into the image
#ADD . /home/bchtester/bitcoin-testnet-box

# make bchtester user own the bitcoin-testnet-box
#RUN chown -R bchtester:bchtester /home/bchtester/bitcoin-testnet-box

# use the bchtester user when running the image
#USER bchtester

# run commands from inside the testnet-box directory
#WORKDIR /home/bchtester/bitcoin-testnet-box


RUN addgroup bitcoin && adduser --gecos "" --home /home/bitcoin --disabled-password --ingroup bitcoin bitcoin
ENV BCH_DATA /data
RUN mkdir "$BCH_DATA" \
        && chown -R bitcoin:bitcoin "$BCH_DATA" \
        && ln -sfn "$BCH_DATA" /home/bitcoin/.bitcoin \
        && chown -h bitcoin:bitcoin /home/bitcoin/.bitcoin
VOLUME /data

WORKDIR /home/bitcoin
ADD . /home/bitcoin/bitcoin-testnet-box
WORKDIR /home/bitcoin/bitcoin-testnet-box

RUN chown -R bitcoin:bitcoin /home/bitcoin/bitcoin-testnet-box


COPY entrypoint.sh /entrypoint.sh
USER bitcoin
ENTRYPOINT ["/entrypoint.sh"]

# expose two rpc ports for the nodes to allow outside container access
EXPOSE 19001 19011
CMD ["/bin/bash"]
