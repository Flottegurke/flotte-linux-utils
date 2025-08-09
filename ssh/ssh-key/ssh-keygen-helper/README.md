# ssh-keygen-helper
This script Helps with the creation of ed25519 SSH-Keys.

## Functionality

Created keys are saved like this: `~/.ssh-keys/keys/<deviceName>_<usecase>.key(.pub)`.

The script also automatically commits the keys to the local (automatically created) git repo at `~/.ssh-keys`.
> [!CAUTION]
> Private keys are also commited to the repo, it is therefore strongly advised to not push the git repo to a server.

## Setup
1. Install all [Dependencies](#Dependencies)
2. If not already done: Execute the [`updateFlotteLinuxUtils.sh`](../../../updateFlotteLinuxUtils.sh) script.  

## How to use
1. Start the script:
    ```shell
    ssh-keygen-helper
    ```
2. Enter (friendly) device name
3. Enter use-case of ssh-key
4. Enter Email or identifier tag
5. (optional) Enter passphrase

## Dependencies
- bash
- mkdir
- ssh-keygen
- chmod
- git

---
## Screenshot
![SSH Key Generation](../../../assets/screenshot-ssh-keygen-helper.png)
