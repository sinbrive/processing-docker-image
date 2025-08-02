FROM ubuntu:22.04

ENV DISPLAY=:0

RUN apt-get update && apt-get install -y openjdk-21-jdk unzip wget 

# Download and install Processing
RUN wget http://github.com/processing/processing4/releases/download/processing-1304-4.4.4/processing-4.4.4-linux-x64-portable.zip \
    -O /tmp/processing.zip \
    && unzip /tmp/processing.zip -d /opt \
    && ln -s /opt/Processing/bin/Processing /usr/local/bin/processing \
    && rm /tmp/processing.zip 

# non-root user
RUN groupadd -r -g 1000 pyuser \
    && useradd -r -u 1000 -g pyuser -m -s /bin/bash pyuser

RUN chown -R pyuser:pyuser /opt/Processing \ 
        && chmod -R 755 /opt/Processing

# Set the working directory in the container
WORKDIR /home/pyuser

# sketches folder
RUN mkdir -p sketches  \
     && chown -R 1000:1000 sketches

# switch to new user
USER 1000:1000

CMD ["/usr/local/bin/processing"]




