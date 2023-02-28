################# BASE IMAGE ######################
FROM --platform=linux/amd64 eclipse-temurin:17-jdk-focal as base

################## METADATA ######################
LABEL base_image="eclipse-temurin:17-jdk-focal"
LABEL version="1.0.0"
LABEL software="Picard Tools"
LABEL software.version="3.0.0"
LABEL about.summary="Picard is a set of command line tools for manipulating high-throughput sequencing (HTS) data and formats such as SAM/BAM/CRAM and VCF. "
LABEL about.home="https://broadinstitute.github.io/picard/"
LABEL about.documentation="https://broadinstitute.github.io/picard/command-line-overview.html"
LABEL about.license_file="https://github.com/broadinstitute/picard/blob/master/LICENSE.txt"
LABEL about.license="MIT"

################## MAINTAINER ######################
MAINTAINER Matthew Galbraith <matthew.galbraith@cuanschutz.edu>
# based on https://github.com/broadinstitute/picard/blob/04e9b204887029827d55a688c4d88f31ca3a32bd/Dockerfile

################## INSTALLATION ######################
ENV DEBIAN_FRONTEND noninteractive
ENV PACKAGES r-base 
# wget tar ca-certificates already present

RUN apt-get update && \
    apt-get install -y --no-install-recommends ${PACKAGES} && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Download release prebuilt jar 3.0.0 from Github
RUN wget https://github.com/broadinstitute/picard/releases/download/3.0.0/picard.jar

# # Download release 3.0.0 from Github
# RUN wget https://github.com/broadinstitute/picard/archive/refs/tags/3.0.0.tar.gz && \
#     tar -xzvf 3.0.0.tar.gz

# WORKDIR picard-3.0.0

# # Build the distribution jar, clean up everything else
# RUN ./gradlew ${build_command} && \
#     mv build/libs/${jar_name} picard.jar && \
#     ./gradlew clean && \
#     rm -rf src && \
#     rm -rf gradle && \
#     rm -rf .git && \
#     rm gradlew && \
#     rm build.gradle

# WORKDIR /