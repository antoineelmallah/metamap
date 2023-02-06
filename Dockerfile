######################################
############ Instalar Java ###########
######################################

FROM ubuntu:22.04 AS java_gawk

RUN bash -c 'mkdir -p /{usr/lib/jvm,install}'

COPY ./instalacao/jre-8u361-linux-x64.tar.gz /install

RUN tar -zxvf /install/jre-8u361-linux-x64.tar.gz -C /usr/lib/jvm

RUN rm -rf /install

RUN mv /usr/lib/jvm/jre1.8.0_361 /usr/lib/jvm/jre

RUN ln -s /usr/lib/jvm/jre /usr/lib/jvm/java-oracle

ENV JAVA_HOME /usr/lib/jvm/java-oracle

ENV PATH ${JAVA_HOME}/bin:$PATH

ENV CLASSPATH ${JAVA_HOME}/lib/tools.jar:$CLASSPATH

# Instalar o gawk
RUN apt update && apt install gawk -y

######################################
############ Instalar LVG ############
######################################

FROM java_gawk AS LVG

RUN mkdir -p /opt/metamap

WORKDIR /opt/metamap/

COPY ./instalacao/lvg2022.tgz .

RUN tar -vzxf ./lvg2022.tgz 

RUN rm ./lvg2022.tgz

COPY ./instalacao/install_linux.sh ./lvg2022/install/bin/

WORKDIR /opt/metamap/lvg2022/

RUN ./install/bin/install_linux.sh

ENV LVG_2022 /opt/metamap/lvg2022

ENV PATH $LVG_2022/bin:$PATH

COPY ./instalacao/lvg /opt/metamap/lvg2022/bin/

######################################
########## Instalar MetaMap ##########
######################################

FROM LVG AS METAMAP

RUN apt update && apt install bzip2 -y

WORKDIR /opt/metamap/

COPY ./instalacao/public_mm_linux_main_2020.tar.bz2 /opt/metamap/

RUN bunzip2 -c public_mm_linux_main_2020.tar.bz2 | tar xvf -

WORKDIR /opt/metamap/public_mm/

ENV PATH /opt/metamap/public_mm/bin:$PATH

RUN ./bin/install.sh

######################################
######## Instalar MetaMap DFB ########
######################################

FROM METAMAP AS MM_DFB

WORKDIR /opt/metamap/

COPY ./instalacao/public_mm_linux_dfb_2021.tar.bz2 .

RUN tar -jxvf public_mm_linux_dfb_2021.tar.bz2

WORKDIR /opt/metamap/public_mm

COPY ["./instalacao/install.sh", "./instalacao/install_dfb.sh", "./bin/"]

RUN ./bin/install.sh

######################################
########### Modelo em PT_BR ##########
######################################

FROM MM_DFB AS PASSO1

WORKDIR /opt/metamap/public_mm

RUN mkdir -p ./sourceData/UMLS_PORTUGUES/umls/

COPY ["instalacao/2022AB/META/MRCONSO.RRF", "instalacao/2022AB/META/MRSAT.RRF", "instalacao/2022AB/META/MRSTY.RRF", "instalacao/2022AB/META/MRSAB.RRF", "instalacao/2022AB/META/MRRANK.RRF", "instalacao/2022AB/LEX/LEX_DB/SM.DB", "./sourceData/UMLS_PORTUGUES/umls/"]

RUN ./bin/skrmedpostctl start

COPY ["instalacao/builddatafiles.sh","./bin/"]

RUN ./bin/BuildDataFiles

WORKDIR /opt/metamap/public_mm/sourceData/UMLS_PORTUGUES/01metawordindex

COPY ["instalacao/01CreateWorkFiles", "instalacao/03FilterPrep", "instalacao/04FilterStrict", "./"]

FROM PASSO1 AS PASSO2

RUN chmod 777 ./01CreateWorkFiles ./02Suppress ./03FilterPrep ./04FilterStrict

RUN ./01CreateWorkFiles && ./02Suppress && ./03FilterPrep

WORKDIR /opt/metamap/public_mm

RUN ./bin/skrmedpostctl start

WORKDIR /opt/metamap/public_mm/sourceData/UMLS_PORTUGUES/01metawordindex

RUN ./04FilterStrict && ./05GenerateMWIFiles

FROM PASSO2 AS PASSO3

WORKDIR /opt/metamap/public_mm/sourceData/UMLS_PORTUGUES/02treecodes

RUN ./01GenerateTreecodes

WORKDIR /opt/metamap/public_mm/sourceData/UMLS_PORTUGUES/03variants

RUN ./01GenerateVariants

WORKDIR /opt/metamap/public_mm/sourceData/UMLS_PORTUGUES/04synonyms

RUN ./01GenerateSynonyms

WORKDIR /opt/metamap/public_mm/sourceData/UMLS_PORTUGUES/05abbrAcronyms

RUN ./01GenerateAbbrAcronyms

WORKDIR /opt/metamap/public_mm/

COPY ["instalacao/loaddatafiles.sh", "./bin/"]

RUN ./bin/LoadDataFiles