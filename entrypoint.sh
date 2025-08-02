#!/bin/sh
mkdir -p /home/pyuser/sketches 
chown -R 1000:1000  /home/pyuser/sketches

su - pyuser

exec "$@"