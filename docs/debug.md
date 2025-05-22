# Debugging

## Things to Check

* RAM utilization -- neobytesd is very hungry and typically needs in excess of 1GB.  A swap file might be necessary.
* Disk utilization -- The neobytes blockchain will continue growing and growing and growing.  Then it will grow some more.  At the time of writing, 40GB+ is necessary.

## Viewing neobytesd Logs

    docker logs neobytesd-node


## Running Bash in Docker Container

*Note:* This container will be run in the same way as the neobytesd node, but will not connect to already running containers or processes.

    docker run -v neobytesd-data:/neobytes --rm -it neobytes/neobytesd bash -l

You can also attach bash into running container to debug running neobytesd

    docker exec -it neobytesd-node bash -l
