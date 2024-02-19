# Dynamic DNS Update Script

This Bash script is designed to update the DNS records of a domain hosted on either GoDaddy or Cloudflare dynamically. It retrieves the current external IP address of the machine it's executed on and compares it with the IP addresses stored in the DNS records. If there's a discrepancy, it updates the DNS records accordingly.

## Credits

This script was inspired by and adapted from the tutorial ["Quick and Dirty Dynamic DNS Using GoDaddy"](https://www.instructables.com/Quick-and-Dirty-Dynamic-DNS-Using-GoDaddy/) on Instructables.

## Usage

1. Ensure you have the required environment variables set properly:
   - `DNS_DOMAIN`: The domain whose DNS records need to be updated.
   - `HOSTNAME`: The hostname whose IP address needs to be updated.
   - `GD_API_KEY`: GoDaddy API key for authentication.
   - `CF_EMAIL` and `CF_API_KEY`: Cloudflare authentication credentials.
   - `logdest`: Destination for logging information.

2. Execute the script. It will fetch the current external IP address, compare it with the IP addresses stored in the DNS records, and update them if necessary.

## Prerequisites

- `jq`: Command-line JSON processor (used for parsing JSON responses).
- `curl`: Command-line tool for transferring data with URLs.
- Ensure you have appropriate permissions to modify DNS records for the specified domain.

## Example

```bash
# Set environment variables
export DNS_DOMAIN="example.com"
export HOSTNAME="subdomain"
export GD_API_KEY="your_godaddy_api_key"
export CF_EMAIL="your_cloudflare_email"
export CF_API_KEY="your_cloudflare_api_key"
export logdest="dns_update.info"

# Execute the script
./dynamic_dns_update.sh
```
