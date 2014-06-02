#! /bin/sh
mkdir --parents /var/run/couchdb
couchdb &
sleep 3s;
echo "Adding Couchdb data"
curl -X PUT http://127.0.0.1:5984/huboard; 
cd /app; couchapp -dc push . http://127.0.0.1:5984/huboard;

echo "Starting application"
foreman start -f /app/Procfile
