FROM ubuntu:latest
RUN apt-get update && apt-get install -y net-tools \
    netcat \
    iputils-ping \
    iputils-tracepath \
    traceroute \
    vim \
    iproute2 \
    curl
CMD ["netcat","-l","80"]
