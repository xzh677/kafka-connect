#!/bin/bash

if [ $# -ne 2 ]; then
  echo "Usage: $0 <host> <port>"
  exit 1
fi

host="$1"
port="$2"
sequence_number=1

while true; do
  priority=$((RANDOM % 8 + 16))  # Generate a random Priority value (16 to 23)
  timestamp=$(date -u +"%Y-%m-%dT%H:%M:%S.%3Z")  # Generate a UTC timestamp
  hostname="test.com"
  tag="su"
  identifier="ID$(($RANDOM % 100))"
  message="Syslog Message $sequence_number"

  syslog_message="<$priority>1 $timestamp $hostname $tag - $identifier - $message"

  echo $syslog_message | nc -v -w 1 $host $port
  echo "sent - $message"

  sequence_number=$((sequence_number + 1))

  # Sleep for a random interval (1 to 5 seconds) before sending the next message
  sleep $(($RANDOM % 5 + 1))
done