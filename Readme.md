# Processing Docker Image

- Tested on WSL2 

1. ### Use standard cli run : create a non-root user (parent folder")

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
