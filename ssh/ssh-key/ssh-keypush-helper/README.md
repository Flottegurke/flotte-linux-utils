# ssh-key-pusher
This script helps with adding local SSH-keys to the `.ssh/authorized_keys` file of servers.

## Functionality
Servers are detected by searching in the local `.ssh/config` file.
> [!TIP]
> To manage the `.ssh/config` file, a tool like [ssh-tui](https://github.com/Flottegurke/ssh-tui) might be useful.

SSH-keys are detected by searching in `~/.ssh-keys/keys/` for `.pub` fies
> [!TIP]
> Keys generated with [ssh-keygen-helper](../ssh-keygen-helper) will be automatically stored there

## Setup
1. Install all [Dependencies](#Dependencies)
2. If not already done: Execute the [`updateFlotteLinuxUtils.sh`](../../../updateFlotteLinuxUtils.sh) script.

## How to use
1. Start the script:
    ```shell
    ssh-keypush-helper
    ```
3. Select the target server
4. Select which SSH-key to add
5. Enter password of server

## Dependencies
- bash
- awk
- fzf
- ssh
- sshpass
- mkdir
- chmod
- cat
- echo
 
## Screenshot
![SSH Key Generation](../../../assets/screenshot-ssh-keypush-helper.png)
