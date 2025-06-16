# ssh-keygen-helper
## Functionality
This script Helps with the creation of ed25519 SSH-Keys.

Created keys are saved like this: `~/.ssh-keys/keys/<deviceName>_<usecase>.key(.pub)`.

The script also automatically commits the keys to the local (automatically created) git repo at `~/.ssh-keys`.
> [!CAUTION]
> Private keys are also commited to the repo, it is therefore strongly advised to not push the git repo to a server.


## Dependencies
- Bash
- ssh-keygen
- git
