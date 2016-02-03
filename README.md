Slackraft
==========


How to run Slackraft
----------------------

1. Install Minecraft [minecraft.net](https://github.com/135yshr/dockercraft)

2. Pull or build Dockercraft image:

    ```
    git clone git@github.com:135yshr/slackcraft.git
    cd slackraft
    docker build -t 135yshr/slackraft .
    ```

3. Run Dockercraft container:

    ```
    docker run -t -i -d -p 25565:25565 -e SORACOM_EMAIL=xxxx@example.com -e SORACOM_PASSWORD=xxxxx 135yshr/slackraft
    ```

4. Open Minecraft > Multiplayer > Add Server

    The server address is the IP of Docker host. No need to specify a port if you used the default one.

    If you're using [Docker Machine](https://docs.docker.com/machine/install-machine/): `docker-machine ip <machine_name>`

5. Join Server!

