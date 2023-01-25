FROM ubuntu:22.04 AS java_gawk

#RUN bash -c 'mkdir -p /{usr/lib/jvm,opt/metamap,MetaMap}'

RUN bash -c 'mkdir -p /{usr/lib/jvm,install}'

COPY ./instalacao/jre-8u361-linux-x64.tar.gz /install

# Copiar arquivos

#COPY jre-8u361-linux-x64.tar.gz /MetaMap

#COPY lvg2022 /MetaMap

#COPY ["jre-8u361-linux-x64.tar.gz", "lvg2022", "/MetaMap/"]

# Instalar o Java 8

#WORKDIR /MetaMap

RUN tar -zxvf /install/jre-8u361-linux-x64.tar.gz -C /usr/lib/jvm

RUN mv /usr/lib/jvm/jre1.8.0_361 /usr/lib/jvm/jre

ENV JAVA_HOME /usr/lib/jvm/jre

ENV PATH ${JAVA_HOME}/bin:$PATH

ENV CLASSPATH ${JAVA_HOME}/lib/tools.jar:$CLASSPATH

# Instalar o gawk

RUN apt update && apt install gawk

# Instalar LVG

#FROM java_gawk AS LVG

#RUN bash -c 'mkdir -p /{install}'

#COPY ["./instalacao/lvg2022.tgz", "./instalacao/install_linux.sh", "/install/"]

#RUN tar -vzxf /install/lvg2022.tgz

#COPY /install/install_linux.sh /install/lvg2022/install/bin/

#RUN /install/lvg2022/install/bin/install_linux.sh

#ENV LVG_2022 /opt/metamap/lvg2022

#ENV PATH $LVG_2022/bin:$PATH

# Instalar MetaMap

