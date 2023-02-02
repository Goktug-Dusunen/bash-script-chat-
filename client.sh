#!/bin/bash

echo "Enter the IP address to connect to:"
read ip

echo "Enter the port to use:"
read port

echo "Enter your username:"
read username

echo "Connecting to $ip:$port as $username..."

# Connect to the remote host as a client
nc "$ip" "$port" << EOF
$username
EOF

# Start reading incoming messages in the background
while read -r message; do
  echo "$message"
done < <(nc -l "$port") &

# Start sending outgoing messages
while true; do
  read -p "> " message
  echo "$username: $message" | nc "$ip" "$port"
done
