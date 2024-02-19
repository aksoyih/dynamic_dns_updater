#!/bin/bash

# Read environment variables
mydomain="$MY_DOMAIN"
myhostname="$MY_HOSTNAME"
gdapikey="$GD_API_KEY"
logdest="$LOG_DEST"

# Ensure required environment variables are set
if [[ -z "$mydomain" || -z "$myhostname" || -z "$gdapikey" || -z "$logdest" ]]; then
  echo "Error: Environment variables not set properly."
  exit 1
fi

# Fetch current IP address
myip=$(curl -s "https://api.ipify.org")

# Fetch current DNS IP address from GoDaddy
dnsdata=$(curl -s -X GET -H "Authorization: sso-key $gdapikey" "https://api.godaddy.com/v1/domains/$mydomain/records/A/$myhostname")
gdip=$(echo "$dnsdata" | cut -d ',' -f 1 | tr -d '"' | cut -d ":" -f 2)

# Log current and GoDaddy DNS IP addresses
echo "$(date '+%Y-%m-%d %H:%M:%S') - Current External IP is $myip, GoDaddy DNS IP is $gdip"

# Compare IP addresses and update GoDaddy DNS if necessary
if [ "$gdip" != "$myip" ] && [ -n "$myip" ]; then
  echo "IP has changed!! Updating on GoDaddy"
  curl -s -X PUT "https://api.godaddy.com/v1/domains/$mydomain/records/A/$myhostname" -H "Authorization: sso-key $gdapikey" -H "Content-Type: application/json" -d "[{\"data\": \"$myip\"}]"
  logger -p "$logdest" "Changed IP on $myhostname.$mydomain from $gdip to $myip"
fi
