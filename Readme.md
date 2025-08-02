# Docker Processing Image


- Tested on WSL2 

2. ### Use compose file : create a non-root user (see sub-folder "compose-version")

- sudo non-root user
    - install sudo (see entrypoint script)
    - new user:
```bash
    RUN useradd -ms /bin/bash pyuser \
        && usermod -aG sudo pyuser \
        && echo "pyuser ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/pyuser \
        && chmod 440 /etc/sudoers.d/pyuser
```

- script entrypoint added (due to: compose file make binding with root:root of sketches folder)
```bash
#!/bin/sh
sudo chown -R pyuser:pyuser  /home/pyuser/sketches
exec "$@"
```

1. ### BRANCH "CLI-RUN" (no use of compose) : Use standard cli run

```bash
# build image (remove --no-cache if needed)
podman build --name procont --no-cache -t processingorg/processing .   
# run 
 podman run -it --rm --name pypcon \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
    -v ./sketches:/home/pyuser/sketches/:z \
    processingorg/processing
```
