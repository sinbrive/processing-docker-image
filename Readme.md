# Docker Processing Image

- Tested on WSL2 
- Podman used instead of Docker

### To do
- Test on native Linux
- ~Fine tune the GUI (still some warnings open)~
- ~Build & push image on Docker Hub~ (see below)

### 1. Main : with docker-compose 
### 2. BRANCH "CLI-RUN" (no use of compose) : Use standard cli run

-----
### Image Publishing on Docker Hub
- How to use it ?
    - Run this (Sketches is your host folder, rename it if need be) :
```bash
  podman run -itd --userns=keep-id  --name processing --rm   \ 
  -e DISPLAY=$DISPLAY    \
  -v /tmp/.X11-unix:/tmp/.X11-unix    \
  -v ./Sketches:/home:rw    \
  sinbrive2/processing-4.4.4:latest

```
- Commands to push
```bash
podman build -t processing-4.4.4 .
podman login docker.io -u docker-username
podman tag processing-4.4.4 docker.io/docker-username/processing-4.4.4:latest
podman push docker.io/docker-username/processing-4.4.4:latest

```

