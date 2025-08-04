#!/bin/sh
sudo chown -R pyuser:pyuser /home/sketches

# echo "Modify string ............"

# cd /home/pyuser/.config/processing

# sed 's/chooser.files.native=true/chooser.files.native=false/' preferences.txt

# cat preferences.txt

# echo "End............"


exec "$@"