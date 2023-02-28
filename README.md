[![Docker Image CI](https://github.com/mattgalbraith/picard-docker-singularity/actions/workflows/docker-image.yml/badge.svg)](https://github.com/mattgalbraith/picard-docker-singularity/actions/workflows/docker-image.yml)

# picard-docker-singularity

## Build Docker container for Picard Tools and (optionally) convert to Apptainer/Singularity.  

Picard is a set of command line tools for manipulating high-throughput sequencing (HTS) data and formats such as SAM/BAM/CRAM and VCF.   
  
#### Requirements:
Java 17  
R  
  
## Build docker container:  

### 1. For Picard installation instructions:  
https://broadinstitute.github.io/picard/  


### 2. Build the Docker Image

#### To build image from the command line:  
``` bash
# Assumes current working directory is the top-level picard-docker-singularity directory
docker build -t picard:3.0.0 . # tag should match software version
```
* Can do this on [Google shell](https://shell.cloud.google.com)

#### To test this tool from the command line:
``` bash
docker run --rm -it picard:3.0.0 java -jar picard.jar -h
docker run --rm -it picard:3.0.0 java -jar picard.jar MarkDuplicates --version
```

## Optional: Conversion of Docker image to Singularity  

### 3. Build a Docker image to run Singularity  
(skip if this image is already on your system)  
https://github.com/mattgalbraith/singularity-docker

### 4. Save Docker image as tar and convert to sif (using singularity run from Docker container)  
``` bash
docker images
docker save <Image_ID> -o picard3.0.0-docker.tar && gzip picard3.0.0-docker.tar # = IMAGE_ID of Picard image
docker run -v "$PWD":/data --rm -it singularity:1.1.5 bash -c "singularity build /data/picard3.0.0.sif docker-archive:///data/picard3.0.0-docker.tar.gz"
```
NB: On Apple M1/M2 machines ensure Singularity image is built with x86_64 architecture or sif may get built with arm64  

Next, transfer the picard3.0.0.sif file to the system on which you want to run Picard from the Singularity container  

### 5. Test singularity container on (HPC) system with Singularity/Apptainer available  
``` bash
# set up path to the Singularity container
PICARD_SIF=path/to/picard3.0.0.sif

# Test that Picard can run from Singularity container
singularity run $PICARD_SIF java -jar /picard.jar -h # depending on system/version, singularity may be called apptainer
```