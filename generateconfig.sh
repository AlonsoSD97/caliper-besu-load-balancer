#!/bin/bash

# Input parameters, por si se quieren pasar de forma externa
# num_nodes=$1
# start_ip=$2
# port=$3

num_nodes=4
start_ip="10.0.64.2"
outputPort=8546
inputPort=8546

# Split the IP address into its components
IFS='.' read -ra ADDR <<< "$start_ip"
base_ip="${ADDR[0]}.${ADDR[1]}.${ADDR[2]}."

# Generate nginx configuration
echo "events {}" > nginx.conf
echo "http {" >> nginx.conf
echo "    upstream websocket {" >> nginx.conf

for ((i=1; i<=$num_nodes; i++))
do
    # Construct the new IP address
    ip="${base_ip}$((${ADDR[3]} + i - 1))"
    server_ip="${ip}:${outputPort}"
    echo "        server $server_ip;" >> nginx.conf
done

echo "    }" >> nginx.conf
echo "" >> nginx.conf
echo "    server {" >> nginx.conf
echo "        listen $inputPort;" >> nginx.conf
echo "" >> nginx.conf
echo "        location / {" >> nginx.conf
echo "            proxy_pass http://websocket;" >> nginx.conf
echo "            proxy_http_version 1.1;" >> nginx.conf
echo "            proxy_set_header Upgrade \$http_upgrade;" >> nginx.conf
echo "            proxy_set_header Connection \"Upgrade\";" >> nginx.conf
echo "        }" >> nginx.conf
echo "    }" >> nginx.conf
echo "}" >> nginx.conf