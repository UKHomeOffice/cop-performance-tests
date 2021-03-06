FROM digitalpatterns/node:4

ENV TAURUS_VERSION 1.13.5


RUN yum install yum-plugin-remove-with-leaves -y && \
  yum install java-1.8.0-openjdk-headless.x86_64 python-devel.x86_64 libxml2-devel.x86_64 \
  libxslt-devel.x86_64 zlib.x86_64 gcc.x86_64 -y && \
  yum -y install python-pip && \
  pip install bzt && \
  pip install s3cmd && \
  yum -y clean all

COPY . /bzt/
COPY config/90-artifacts-dir.json /etc/bzt.d/
COPY config/90-no-console.json /etc/bzt.d/

RUN chown -R "$USER":"$GROUP" /bzt

USER 1000

VOLUME ["/bzt"]

WORKDIR /bzt
