# sort-files-by-extension
## Functionality
This script recursively sorts all files in the directory the file gets executed from by moving them into directory's named after their extension.

The script automatically creates the directories if they do not already exist and removes old (not empty) ones.

> [!CAUTION]
> After execution of this script, the complete folder structure is lost, due to this script recursively searching for files, and moving them regardless of subdirectories.

## How to use
To use the script, just execute it, after installing all necessary dependencies.


### Screenshot
![SSH Key Generation](../../../assets/sscreenshot-sort-files-by-extension.png)

> [!CAUTION]
> Make sure to run the script in the directory you want to sort, as it will move files from the current directory and all subdirectories.

## Dependencies
- Bash
