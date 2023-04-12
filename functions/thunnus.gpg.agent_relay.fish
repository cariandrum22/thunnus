# Launches socat+wsl-relay to relay the gpg-agent socket file for use in WSL
# Rewritten based on code at https://justyn.io/blog/using-a-yubikey-for-gpg-in-windows-10-wsl-windows-subsystem-for-linux/

function thunnus.gpg.agent_relay -d "Using socat and WSL-Relay to achieve Smart Card signatures on WSL"
  set -l windows_username (cmd.exe /c "echo|set /p=%USERNAME%")
  
  set -l gpgdir "$HOME/.gnupg"
  set -l pid "$gpgdir/gpg-agent-relay.pid"
  set -l prev_pid (cat $pid)
  
  if [ ! -z "$prev_pid" ]
    ps -p "$prev_pid" >/dev/null && \
    echo "gpg-agent-relay already running with process id $prev_pid" && \
    exit 0
  end
  
  echo $fish_pid > $pid
  
  rm -f "$gpgdir/S.gpg-agent*"
  
  socat UNIX-LISTEN:"$gpgdir/S.gpg-agent",fork, EXEC:"\'/mnt/c/Users/$windows_username/Go/bin/wsl-relay.exe\' --input-closes --pipe-closes --gpg",nofork &
end
