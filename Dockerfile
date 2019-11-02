FROM golang:1.13.3-buster
LABEL maintainer="marcgwilson"

RUN export DEBIAN_FRONTEND=noninteractive && \
	apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    build-essential software-properties-common \
    wget curl unzip sqlite3 jq

EXPOSE 8000

ADD ./todo /todo

WORKDIR /todo

RUN go install

ENTRYPOINT ["todo"]
