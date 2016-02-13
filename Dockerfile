FROM golang:1.5.1

RUN export SORACOM_EMAIL={USER_EMAIL}
RUN export SORACOM_PASSWORD={PASSWORD}

# Copy Go code and install applications
COPY ./goproxy /go/src/goproxy
RUN go get github.com/135yshr/goracom
RUN cd /go/src/goproxy; go install

# Download Cuberite server (Minecraft C++ server)
# and load up a special empty world for Dockercraft
WORKDIR /srv
RUN sh -c "$(wget -qO - https://raw.githubusercontent.com/cuberite/cuberite/master/easyinstall.sh)" && mv Server cuberite_server
COPY ./world world
COPY ./docs/img/logo64x64.png logo.png

COPY ./start.sh start.sh
CMD ["/bin/bash","/srv/start.sh"]
