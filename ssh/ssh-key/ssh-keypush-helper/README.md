# ssh-key-pusher
## Functionality
This script helps with adding local SSH-keys to the `.ssh/authorized_keys` file of servers.

Servers are detected by searching in the local `.ssh/config` file.
> [!TIP]
> To manage the `.ssh/config`, a tool like [ssh-tui](https://github.com/Flottegurke/ssh-tui) might be useful.

SSH-keys are detected by searching in `~/.ssh-keys/keys/` for `.pub` fies
> [!TIP]
> Keys generated with [ssh-keygen-helper](../ssh-keygen-helper) will be automatically stored there

## How to use
To use the script, just execute it, after installing all necessary dependencies.

1. select the server to which to add the SSH-key
2. select which SSH-key to add
3. enter password of server

## Dependencies
- Bash
- fzf
- sshpass
