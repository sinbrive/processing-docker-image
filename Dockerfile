FROM ubuntu:24.04

ENV DISPLAY=:0

# Install only the JRE if you don't need development tools
RUN apt-get update \
    # && apt-get install -y openjdk-17-jdk unzip wget sudo \
    && apt-get install -y unzip wget sudo \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
# ENV PATH $JAVA_HOME/bin:$PATH

# Download and install Processing (zip file)
RUN wget http://github.com/processing/processing4/releases/download/processing-1304-4.4.4/processing-4.4.4-linux-x64-portable.zip \
    -O /tmp/processing.zip \
    && unzip /tmp/processing.zip -d /opt \
    && ln -s /opt/Processing/bin/Processing /usr/local/bin/processing \
    && rm /tmp/processing.zip 


# # Processing v3.5
# RUN wget https://github.com/processing/processing/releases/download/processing-0266-3.5/processing-3.5-linux64.tgz \
#     && tar -xvf processing-3.5-linux64.tgz -C /opt \
#     && ln -s /opt/processing-3.5/processing /usr/local/bin/processing \
#     && rm processing-3.5-linux64.tgz


# non-root sudo user
RUN useradd -ms /bin/bash pyuser \
    && usermod -aG sudo pyuser \
    && echo "pyuser ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/pyuser \
    && chmod 440 /etc/sudoers.d/pyuser

RUN chown -R pyuser:pyuser /opt/Processing  /home  \
        && chmod -R 755 /opt/Processing /home


# Set the working directory in the container
WORKDIR /home

# script 
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# create sketches folder
# RUN mkdir -p sketches

# switch to new user
USER pyuser

# create sketches folder
RUN mkdir -p sketches

# make sketches/ folder owned by pyuser (RUN chown ... not working) 
ENTRYPOINT ["/entrypoint.sh"]

# CMD ["/bin/bash"]

CMD ["/usr/local/bin/processing"]



