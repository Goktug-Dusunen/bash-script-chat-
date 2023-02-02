#!/bin/bash

echo "Enter the IP address to connect to:"
read ip

echo "Enter the port to use:"
read port

echo "Enter your username:"
read username
echo "$username" | gpg --encrypt > encrypted.gpg
s=$(cat encrypted.gpg)
rm encrypted.gpg


echo "Connecting to $ip:$port as $username..."

# Connect to the remote host as a client
nc "$ip" "$port" << EOF
$s
EOF

# Start reading incoming messages in the background
while read -r message; do
  echo "$message"
done < <(nc -l "$port") &

# Start sending outgoing messages
while true; do
  read -p "> " message
  echo "$message" | gpg --encrypt > encryptedm.gpg
  pow=(cat encryptedm.gpg)
  rm encryptedm.gpg
  echo "$s: $pow" | nc "$ip" "$port"
done
