# update-helper
This script helps with updating system packages and other repos.

## Functionality
The script firstly updates system packages (using yay (or pacman if yay is not installed)).
Then it checks, if a dotfiles repo is located in `~/.config`, and if it is, tries to execute `~/-config/dotfiles/updateDtfiles.sh`
> [!TIP]
> For inspiration on how to set up your `updateDotfiles.sh` script, have a look at [my dotfiles](https://github.com/Flottegurke/dotfiles/blob/main/updateDotfiles.sh)

## How to use
1. Install all [Dependencies](#Dependencies)
2. Execute the script:
    ```shell
    ./update-helper.sh
    ```
3. Confirm that you want to update the system
4. Choose whether the system should reboot

## Dependencies
- pacman
- yay (optional)

---
### Screenshot
![SSH Key Generation](../../assets/screenshot-update-helper.png)
