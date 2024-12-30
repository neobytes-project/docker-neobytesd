neobytesd config tuning
======================

You can use environment variables to customize config ([see docker run environment options](https://docs.docker.com/engine/reference/run/#/env-environment-variables)):

        docker run -v neobytesd-data:/neobytes/.neobytes --name=neobytesd-node -d \
            -p 1428:1428 \
            -p 127.0.0.1:1427:1427 \
            -e REGTEST=0 \
            -e DISABLEWALLET=1 \
            -e PRINTTOCONSOLE=1 \
            -e RPCUSER=mysecretrpcuser \
            -e RPCPASSWORD=mysecretrpcpassword \
            sikkienl/neobytesd

Or you can use your very own config file like that:

        docker run -v neobytesd-data:/neobytes/.neobytes --name=neobytesd-node -d \
            -p 1428:1428 \
            -p 127.0.0.1:1427:1427 \
            -v /etc/neobytes.conf:/neobytes/.neobytes/neobytes.conf \
            sikkienl/neobytesd
            