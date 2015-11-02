FROM ubuntu:trusty
MAINTAINER bn0ir <gblacknoir@gmail.com>

RUN apt-get update && \
        apt-get install -y \
                software-properties-common && \
        add-apt-repository ppa:webupd8team/java -y && \
        echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
        echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections && \
        apt-get update && \
        apt-get install -y \
                oracle-java7-installer && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir -p /usr/local/s3proxy && \
		cd /usr/local/s3proxy && \
		wget https://github.com/andrewgaul/s3proxy/releases/download/s3proxy-1.4.0/s3proxy && \
		chmod +x s3proxy

RUN mkdir -p /data

WORKDIR /usr/local/s3proxy

ADD ./run_s3proxy.sh /usr/local/s3proxy/run_s3proxy.sh
ADD ./s3proxy.conf /usr/local/s3proxy/s3proxy.conf

CMD ["/usr/local/s3proxy/run_s3proxy.sh"]

EXPOSE 8080

VOLUME /data