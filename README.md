Slackraft
==========


How to run Slackraft
----------------------

1. Install Minecraft [minecraft.net](https://minecraft.net)

2. Pull or build Dockercraft image:

    ```
    git clone https://github.com/135yshr/slackraft.git
    docker build -t 135yshr/slackraft slackraft
    ```

3. Run Dockercraft container:

    ```
    docker run -t -i -d -p 25565:25565 135yshr/slackraft
    ```

4. Open Minecraft > Multiplayer > Add Server

    The server address is the IP of Docker host. No need to specify a port if you used the default one.

    If you're using [Docker Machine](https://docs.docker.com/machine/install-machine/): `docker-machine ip <machine_name>`

5. Join Server!


License
--------

Based on the [Dockercraft](https://github.com/docker/dockercraft) has created a Slackraft.
