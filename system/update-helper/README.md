# update-helper
This script helps with updating system packages and other repos.

## Functionality
The script updates system packages using yay or (pacman if yay is not installed).

The script also searches for a `~/.config/dotfiles` directory, which wen found gets updated (git pull). After this a `updateDotfiles.sh` file is expected, which gets run by this script after git is finished.
> [!TIP]
> For inspiration on how to set up your `updateDotfiles.sh` script, have a look at [my dotfiles](https://github.com/Flottegurke/dotfiles/blob/main/updateDotfiles.sh)

After this, the script updates the local version of this repo (expected in `~/.config/flotte-linux-utils`) by executing `git pull` and then the `updateFlotteLinuxUtils.sh` file.

## Setup
1. Install all [Dependencies](#Dependencies)
2. If not already done: Execute the [`updateFlotteLinuxUtils.sh`](../../updateFlotteLinuxUtils.sh) script.

## How to use
1. Start the script:
    ```shell
    update-helper
    ```
2. Confirm that you want to update the system
3. Choose whether your machine should reboot

## Dependencies
- bash
- systemctl
- pacman
- git
- yay (optional)

---
### Screenshot
![SSH Key Generation](../../assets/screenshot-update-helper.png)
