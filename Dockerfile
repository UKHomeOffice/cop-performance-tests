FROM quay.io/ukhomeofficedigital/python:v3.4.3

ENV TAURUS_VERSION 1.13.5

RUN yum install yum-plugin-remove-with-leaves -y && \
  yum install java-1.8.0-openjdk-headless.x86_64 python34-devel.x86_64 libxml2-devel.x86_64 \
  libxslt-devel.x86_64 zlib.x86_64 gcc.x86_64 -y

RUN pip install bzt

RUN pip install s3cmd

RUN yum remove python34-devel.x86_64 libxml2-devel.x86_64 libxslt-devel.x86_64 gcc.x86_64 --remove-leaves -y

ADD config/90-artifacts-dir.json /etc/bzt.d/

ADD config/90-no-console.json /etc/bzt.d/

COPY . /bzt/

RUN groupadd -g 1000 platformtestuser && \
 useradd -g 1000 -u 1000 platformtestuser

RUN chown -R platformtestuser:platformtestuser /bzt

VOLUME ["/bzt"]

USER platformtestuser

WORKDIR /bzt
