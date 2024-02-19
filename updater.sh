#!/bin/bash

# Read environment variables
mydomain="$MY_DOMAIN"
myhostname="$MY_HOSTNAME"
gdapikey="$GD_API_KEY"
cfemail="$CF_EMAIL"
cfapikey="$CF_API_KEY"
logdest="$LOG_DEST"

# Ensure required environment variables are set
if [[ -z "$mydomain" || -z "$myhostname" || -z "$gdapikey" || -z "$cfemail" || -z "$cfapikey" || -z "$logdest" ]]; then
  echo "Error: Environment variables not set properly."
  exit 1
fi

# Fetch current IP address
myip=$(curl -s "https://api.ipify.org")

# Fetch current DNS IP address from GoDaddy
dnsdata=$(curl -s -X GET -H "Authorization: sso-key $gdapikey" "https://api.godaddy.com/v1/domains/$mydomain/records/A/$myhostname")
gdip=$(echo "$dnsdata" | jq -r '.[].data')

# Fetch current DNS IP address from Cloudflare
cfip=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones?name=$mydomain" -H "X-Auth-Email: $cfemail" -H "X-Auth-Key: $cfapikey" -H "Content-Type: application/json" | jq -r '.result[0].id' | xargs -I {} curl -s -X GET "https://api.cloudflare.com/client/v4/zones/{}/dns_records?type=A&name=$myhostname.$mydomain" -H "X-Auth-Email: $cfemail" -H "X-Auth-Key: $cfapikey" -H "Content-Type: application/json" | jq -r '.result[0].content')

# Log current and GoDaddy DNS IP addresses
echo "$(date '+%Y-%m-%d %H:%M:%S') - Current External IP is $myip, GoDaddy DNS IP is $gdip, Cloudflare DNS IP is $cfip"

# Compare IP addresses and update GoDaddy DNS if necessary
if [ "$gdip" != "$myip" ] && [ -n "$myip" ]; then
  echo "IP has changed!! Updating on GoDaddy"
  curl -s -X PUT "https://api.godaddy.com/v1/domains/$mydomain/records/A/$myhostname" -H "Authorization: sso-key $gdapikey" -H "Content-Type: application/json" -d "[{\"data\": \"$myip\"}]"
  logger -p "$logdest" "Changed IP on $myhostname.$mydomain from $gdip to $myip"
fi

# Compare IP addresses and update Cloudflare DNS if necessary
if [ "$cfip" != "$myip" ] && [ -n "$myip" ]; then
  echo "IP has changed!! Updating on Cloudflare"
  zone_id=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones?name=$mydomain" -H "X-Auth-Email: $cfemail" -H "X-Auth-Key: $cfapikey" -H "Content-Type: application/json" | jq -r '.result[0].id')
  record_id=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$zone_id/dns_records?type=A&name=$myhostname.$mydomain" -H "X-Auth-Email: $cfemail" -H "X-Auth-Key: $cfapikey" -H "Content-Type: application/json" | jq -r '.result[0].id')
  curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$zone_id/dns_records/$record_id" -H "X-Auth-Email: $cfemail" -H "X-Auth-Key: $cfapikey" -H "Content-Type: application/json" --data "{\"type\":\"A\",\"name\":\"$myhostname.$mydomain\",\"content\":\"$myip\",\"ttl\":120,\"proxied\":false}"
  logger -p "$logdest" "Changed IP on $myhostname.$mydomain from $cfip to $myip"
fi
