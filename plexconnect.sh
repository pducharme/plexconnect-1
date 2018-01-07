#!/bin/bash
#If this is the first time you run the container, clone (get) PlexConnect, else update
if [ ! -f /opt/PlexConnect/ATVSettings.cfg ]; then
  cd /opt
  git clone https://github.com/iBaa/PlexConnect.git
else
  cd /opt/PlexConnect
  git pull
fi

# Generate SSL certificates if they don't exist
if [ -f /opt/PlexConnect/assets/certificates/trailers.pem ] ; then
  echo "SSL certs exist"
else
  openssl req -new -nodes -newkey rsa:2048 -out /opt/PlexConnect/assets/certificates/trailers.pem -keyout /opt/PlexConnect/assets/certificates/trailers.key -x509 -days 7300 -subj "/C=US/CN=trailers.apple.com"
  openssl x509 -in /opt/PlexConnect/assets/certificates/trailers.pem -outform der -out /opt/PlexConnect/assets/certificates/trailers.cer && cat /opt/PlexConnect/assets/certificates/trailers.key >> /opt/PlexConnect/assets/certificates/trailers.pem
fi

#Correct ownership
chown nobody:users /opt/PlexConnect

# Run PlexConnect  
echo "*** Launching PlexConnect..."
python /opt/PlexConnect/PlexConnect.py

