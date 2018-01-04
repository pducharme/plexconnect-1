#!/bin/bash
#If this is the first time you run the container, clone (get) PlexConnect, else update
if [ ! -f /PlexConnect/ATVSettings.cfg ]; then
  cd /opt
  git clone https://github.com/iBaa/PlexConnect.git
else
  cd /opt/PlexConnect
  git pull
fi

# Generate SSL certificates if they don't exist
if [ -f /opt/plexconnect/assets/certificates/trailers.pem ] ; then
  echo "SSL certs exist"
else
  openssl req -new -nodes -newkey rsa:2048 -out /opt/plexconnect/assets/certificates/trailers.pem -keyout /opt/plexconnect/assets/certificates/trailers.key -x509 -days 7300 -subj "/C=US/CN=trailers.apple.com"
  openssl x509 -in /opt/plexconnect/assets/certificates/trailers.pem -outform der -out /opt/plexconnect/assets/certificates/trailers.cer && cat /opt/plexconnect/assets/certificates/trailers.key >> /opt/plexconnect/assets/certificates/trailers.pem
fi

#Correct ownership
chown nobody:users /opt/plexconnect

# Run PlexConnect  
echo "*** Launching PlexConnect..."
exec /usr/bin/python /opt/plexconnect/PlexConnect.py

