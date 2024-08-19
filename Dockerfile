FROM ubuntu:24.04

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y cpu-checker
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

CMD ["/bin/bash"]