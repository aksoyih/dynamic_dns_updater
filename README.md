# Dynamic DNS Updater

This Bash script updates the DNS record of a specified domain hosted on GoDaddy to match the current external IP address of the machine where the script is executed. It is particularly useful for maintaining a dynamic DNS setup.

## Source and Inspiration

This script was inspired by and adapted from the tutorial ["Quick and Dirty Dynamic DNS Using GoDaddy"](https://www.instructables.com/Quick-and-Dirty-Dynamic-DNS-Using-GoDaddy/) on Instructables.

## Prerequisites

Before using this script, ensure you have the following:

- **GoDaddy API Key**: Obtain an API key from your GoDaddy account with permissions to manage DNS records.
- **Environment Variables**:
  - `MY_DOMAIN`: Your domain hosted on GoDaddy.
  - `MY_HOSTNAME`: The hostname (subdomain) whose DNS record needs to be updated.
  - `GD_API_KEY`: Your GoDaddy API key.
  - `LOG_DEST`: Destination for logging (e.g., syslog).

## Usage

1. Set up the required environment variables.
2. Execute the script.

```bash
chmod +x dynamic_dns_updater.sh
./dynamic_dns_updater.sh
```

## Functionality

1. Reads environment variables to get domain, hostname, GoDaddy API key, and log destination.
2. Fetches the current external IP address.
3. Retrieves the current DNS IP address from GoDaddy.
4. Compares the current and DNS IP addresses.
5. If they differ, updates the GoDaddy DNS record with the current IP address.

## Notes

- This script uses the `curl` command for HTTP requests.
- Ensure that the machine running this script has proper network connectivity.
- Logging is optional but recommended for tracking IP changes.

## License

This project is licensed under the [MIT License](LICENSE).
