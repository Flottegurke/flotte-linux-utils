# flotte-linux-utils
This is a collection of helpful linux scripts, which streamline some tedious tasks.

## Usage
1. Clone the repo into `~/.config`:
    ```shell
    cd ~/.config && git clone git@github.com:flottegurke/flotte-linux-utils.git
    ```
    > [!WARNING]
    > The repo needs to get cloned into the `~/.config` directory with the name `flotte-linux-utils` in order for the [update-helper Script](./system/update-helper/update-helper.sh) to work.
2. Execute `updateFlotteLinuxUtils.sh`:
    ```shell
    ./updateFlotteLinuxUtils.sh
    ```
    > [!TIP]
    > After you have executed `updateFlotteLinuxUtils.sh` once, you can just run `update-helper` (from anywhere) to update this repo (and your system packages). 

## Structure
Scripts are grouped by topic to keep things organized.

Each script has its own `README.md` file that explains:
- What the script does
- How to use it
- Which Dependencies are required

---
# Overview
- ## [ssh](ssh)
    - ### [ssh-key](ssh/ssh-key)
        - **[ssh-keygen-helper](ssh/ssh-key/ssh-keygen-helper)**
          Helps with the creation of SSH-keys
        - **[ssh-key-pusher](ssh/ssh-key/ssh-keypush-helper)**
          Helps with adding SSH-keys to servers based on the `.ssh/config` file
- ## [file](file)
    - ### [file-sorting](file/file-sorting)
        - **[sort-files-by-extension](file/file-sorting/sort-files-by-extension)**
          Recursively sorts files by their extension into directories
- ## [system](system)
    - **[update-helper](system/update-helper)**
        Helps with updating the system packages
