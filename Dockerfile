######################################
############ Instalar Java ###########
######################################

FROM ubuntu:22.04 AS java_gawk

RUN bash -c 'mkdir -p /{usr/lib/jvm,install}'

COPY ./instalacao/jre-8u361-linux-x64.tar.gz /install

RUN tar -zxvf /install/jre-8u361-linux-x64.tar.gz -C /usr/lib/jvm

RUN rm -rf /install

RUN mv /usr/lib/jvm/jre1.8.0_361 /usr/lib/jvm/jre

ENV JAVA_HOME /usr/lib/jvm/jre

ENV PATH ${JAVA_HOME}/bin:$PATH

ENV CLASSPATH ${JAVA_HOME}/lib/tools.jar:$CLASSPATH

# Instalar o gawk
RUN apt update && apt install gawk -y

######################################
############ Instalar LVG ############
######################################

FROM java_gawk AS LVG

RUN mkdir -p /{install,opt/metamap}

WORKDIR /opt/metamap/

#COPY ["./instalacao/lvg2022.tgz", "./instalacao/install_linux.sh", "/install/"]
COPY ./instalacao/lvg2022.tgz .

RUN tar -vzxf ./lvg2022.tgz 

RUN rm ./lvg2022.tgz

COPY ./instalacao/install_linux.sh ./lvg2022/install/bin/

WORKDIR /opt/metamap/lvg2022/

RUN ./install/bin/install_linux.sh

ENV LVG_2022 /opt/metamap/lvg2022

ENV PATH $LVG_2022/bin:$PATH

RUN rm -rf /install

# Instalar MetaMap

