# Docker Processing Image


- Tested on WSL2 
- Podman used instead of Docker

### To do
- Test on native Linux
- Fine tune the GUI (still some warnings open)
- Build & push image on Docker Hub

1. ### Use compose file : create a non-root user (see sub-folder "compose-version")

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

- Main commands 
```bash
 podman-compose up -d --build
 podman-compose down
 podman exec -it pypcon bash
 podman rm -f pypcon
 podman logs pypcon
```

2. ### BRANCH "CLI-RUN" (no use of compose) : Use standard cli run

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
