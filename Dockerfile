FROM ubuntu:22.04

ENV DISPLAY=:0

RUN apt-get update && apt-get install -y openjdk-21-jdk unzip wget sudo

# Download and install Processing
RUN wget http://github.com/processing/processing4/releases/download/processing-1304-4.4.4/processing-4.4.4-linux-x64-portable.zip \
    -O /tmp/processing.zip \
    && unzip /tmp/processing.zip -d /opt \
    && ln -s /opt/Processing/bin/Processing /usr/local/bin/processing \
    && rm /tmp/processing.zip 

# Set the working directory in the container
WORKDIR /home

# Call processing
CMD ["/usr/local/bin/processing"]




