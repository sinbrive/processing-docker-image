FROM ubuntu:22.04

ENV DISPLAY=:0

RUN apt-get update && apt-get install -y openjdk-21-jdk unzip wget sudo

# Download and install Processing
RUN wget http://github.com/processing/processing4/releases/download/processing-1304-4.4.4/processing-4.4.4-linux-x64-portable.zip \
    -O /tmp/processing.zip \
    && unzip /tmp/processing.zip -d /opt \
    && ln -s /opt/Processing/bin/Processing /usr/local/bin/processing \
    && rm /tmp/processing.zip 

# non-root sudo user
RUN useradd -ms /bin/bash pyuser \
    && usermod -aG sudo pyuser \
    && echo "pyuser ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/pyuser \
    && chmod 440 /etc/sudoers.d/pyuser

# RUN chown -R pyuser:pyuser /opt/Processing \ 
#         && chmod -R 755 /opt/Processing

# Set the working directory in the container
WORKDIR /home/pyuser

# script 
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# create sketches folder
RUN mkdir -p sketches

# switch to new user
USER pyuser

# make sketches/ folder owned by pyuser (RUN chown ... not working) 
ENTRYPOINT ["/entrypoint.sh"]

CMD ["/usr/local/bin/processing"]




