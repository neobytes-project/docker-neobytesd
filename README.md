Neobytesd for Docker
====================

Docker image that runs the Neobytes neobytesd node in a container for easy deployment.

Quick Start
-----------

1. Create a `neobytesd-data` volume to persist the neobytesd blockchain data, should exit immediately.  The `neobytesd-data` container will store the blockchain when the node container is recreated (software upgrade, reboot, etc):

        docker volume create --name=neobytesd-data
        docker run -v neobytesd-data:/neobytes/.neobytes --name=neobytesd-node -d \
            -p 1428:1428 \
            -p 127.0.0.1:1427:1427 \
            sikkienl/neobytesd

2. Verify that the container is running and neobytesd node is downloading the blockchain

        $ docker ps
        CONTAINER ID        IMAGE                         COMMAND             CREATED             STATUS              PORTS                                              NAMES
        d0e1076b2dca        sikkienl/neobytesd:latest     "nby_oneshot"       2 seconds ago       Up 1 seconds        127.0.0.1:1427->1427/tcp, 0.0.0.0:148->1428/tcp   neobytesd-node

3. You can then access the daemon's output thanks to the [docker logs command]( https://docs.docker.com/reference/commandline/cli/#logs)

        docker logs -f neobytesd-node

4. Install optional init scripts for upstart and systemd are in the `init` directory.

