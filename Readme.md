# Docker Processing Image

- Tested on WSL2 
- Podman used instead of Docker

### To do
- Test on native Linux
- Fine tune the GUI (still some warnings open)
- ~Build & push image on Docker Hub~ (see below)

### 1. Use compose file : create a non-root user (see sub-folder "compose-version")

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

---

### 2. BRANCH "CLI-RUN" (no use of compose) : Use standard cli run

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

---

### Image on Docker Hub
- How to use it ?
    - Run this (Sketches is your host folder, rename it if need be) :
```bash
  podman run -itd --userns=keep-id  --name processing --rm   \ 
  -e DISPLAY=$DISPLAY    \
  -v /tmp/.X11-unix:/tmp/.X11-unix    \
  -v ./Sketches:/home/pyuser/sketches:rw    \
  sinbrive2/processing-4.4.4:latest

```
- Commands to push
```bash
podman build -t processing-4.4.4 .
podman login docker.io -u docker-username
podman tag processing-4.4.4 docker.io/docker-username/processing-4.4.4:latest
podman push docker.io/docker-username/processing-4.4.4:latest

```

----
### Using Volume with root user
- Create volume
- update compose file
- remove entrypoint script
- update dockerfile
- change preferences in Processing
- commands
```bash
    podman volume create sk_volume
    podman volume inspect sk_volume # to see where it is: /home/USER/.local/share/containers/storage/volumes/sk_volume/_data
    podman volume
    podman volume ls
``` 
- compose file
```bash
services:
  processing:
    build: .
    container_name: pypcon
    environment:
      - DISPLAY=${DISPLAY}
    volumes:
      - /tmp/.X11-unix:/tmp/.X11-unix:ro
      - py_data:/home/pyuser
volumes:
  py_data:
    name: sk_volume
```
- bind the volume to a desired folder
    - create volume like this
```bash
docker volume create --driver local \
  --opt type=none \
  --opt device=$(pwd)/Folder \
  --opt o=bind \
  volume_name
  ``` 

sed 's/chooser.files.native=true/chooser.files.native=false/' preferences.txt

docker crée une image à chaque lancement si difference (pour des commit eventuellement)

docker rmi -f image_name

podman-compose up -d --build --no-cache 

podman-compose up -d --build # build always and if needed add --no-cache

- sometimes y need to remove the image
    -  podman images
    - podman rmi image_id

- Error in Python mode:
    - Cannot invoke "processing.app.SketchCode.isModified()" because "this.current" is null
    - https://github.com/benfry/processing4/issues/719

### podman-composer: maintaining correct file ownership between host and container
- create sudo non-root user
```bash
RUN useradd -ms /bin/bash pyuser \
    && usermod -aG sudo pyuser \
    && echo "pyuser ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/pyuser \
    && chmod 440 /etc/sudoers.d/pyuser

RUN chown -R pyuser:pyuser /opt/Processing  /home \
        && chmod -R 755 /opt/Processing

# Set the working directory in the container
WORKDIR /home

```
- bind the volume to a desired folder
    - create volume like this
```bash
docker volume create --driver local \
  --opt type=none \
  --opt device=$(pwd)/Folder \
  --opt o=bind \
  volume_name
  ``` 
  - in compose file
```bash
      volumes:
      - /tmp/.X11-unix:/tmp/.X11-unix:ro
      - py_data:/home/pyuser
volumes:
  py_data:
    name: sk_volume
 ``` 


