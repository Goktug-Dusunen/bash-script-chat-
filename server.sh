#!/bin/bash

echo "Enter the port to listen on:"
read port

echo "Listening on port $port..."

while true; do
  # Accept incoming connections
  read -r username message < <(nc -l "$port")
  echo "$username: $message"
done
