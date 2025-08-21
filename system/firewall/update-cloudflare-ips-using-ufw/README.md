# update-cloudflare-ips-using-ufw
Updates ufw (firewall) rules to only accept incoming traffic from cloudflare IPs

## Functionality
This script automatically updates the machine, to only accept incoming traffic from Cloudflare IPs. This is helpful on servers, as Cloudflare regularly updates their IP ranges.

Upon execution of this script, firstly all old Cloudflare IP ranges get deleted.
Other Firewall rules stay intact.

> [!TIP]
> This script is especially helpfully, when run via a cron job every day:
> Edit `crontab -e` and add `0 3 * * * /usr/local/bin/update-cloudflare-ips-using-ufw.sh`

## Setup
1. Install all [Dependencies](#Dependencies)
2. If not already done: Execute the [`updateFlotteLinuxUtils.sh`](../../../updateFlotteLinuxUtils.sh) script.

## How to use
1. Start the script:
    ```shell
    update-cloudflare-ips-using-ufw
    ```
## Dependencies
- ufw
- grep
- awk
- tac
- curl
