# flotte-linux-utils
This is a collection of helpful linux scripts, which streamline some tedious tasks.

## Usage
You can either clone the entire repository or just copy the scripts you need:
```shell
git clone git@github.com:flottegurke/flotte-linux-utils.git
```

## Structure
Scripts are grouped by topic to keep things organized.

Each script has its own `README.md` file that explains:
- What the script does
- How to use it
- Which Dependencies are required

# Script Overview
- # [ssh](ssh)
    - ## [ssh-key](ssh/ssh-key)
        - ### [ssh-keygen-helper](ssh/ssh-key/ssh-keygen-helper)
          Helps with the creation of SSH-keys
        - ### [ssh-key-pusher](ssh/ssh-key/ssh-keypush-helper)
          Helps with adding SSH-keys to servers based on the `.ssh/config` file
- # [file](file)
    - ## [file-sorting](file/file-sorting)
        - ### [sort-files-by-extension](file/file-sorting/sort-files-by-extension)
          Recursively sorts files by their extension into directories