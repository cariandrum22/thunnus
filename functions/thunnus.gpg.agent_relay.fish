# Relay Windows gpg-agent into WSL via wsl-relay + socat (fish)
function thunnus.gpg.agent_relay -d "Relay Windows gpg-agent socket into WSL (fish)"
    # Get actual gpg socket path
    set -l sock (gpgconf --list-dirs agent-socket 2>/dev/null)
    test -z "$sock"; and echo "Failed to get agent-socket path" >&2; and return 1
    
    set -l sockdir (dirname "$sock")
    set -l gpgdir "$HOME/.gnupg"
    set -l pidfile "$gpgdir/gpg-agent-relay.pid"
    
    # Check existing relay process
    if test -f "$pidfile"
        set -l prev_pid (cat "$pidfile" 2>/dev/null)
        if test -n "$prev_pid"; and kill -0 "$prev_pid" 2>/dev/null
            echo "Relay already running (PID: $prev_pid)"
            return 0
        end
    end
    
    # Find wsl-relay.exe
    set -l wsl_relay (command -v wsl-relay.exe 2>/dev/null)
    if test -z "$wsl_relay"
        set -l windows_username (cmd.exe /c "echo %USERNAME%" 2>/dev/null | string trim)
        set wsl_relay "/mnt/c/Users/$windows_username/Go/bin/wsl-relay.exe"
    end
    test -x "$wsl_relay"; or begin
        echo "wsl-relay.exe not found or not executable" >&2
        return 1
    end
    
    # Stop local gpg services to avoid conflicts
    gpgconf --kill scdaemon 2>/dev/null
    gpgconf --kill gpg-agent 2>/dev/null
    
    # Prepare socket directory and file
    mkdir -p "$sockdir" "$gpgdir"
    chmod 700 "$sockdir" "$gpgdir"
    test -S "$sock"; and rm -f "$sock"
    
    # Start relay
    socat UNIX-LISTEN:"$sock",fork,umask=077,mode=0600 \
          EXEC:"'$wsl_relay' --input-closes --pipe-closes --gpg",nofork &
    set -l socat_pid $last_pid
    
    # Save PID
    echo $socat_pid > "$pidfile"
    disown $socat_pid
    
    # Create compatibility symlink if needed
    if test "$sock" != "$gpgdir/S.gpg-agent"
        rm -f "$gpgdir/S.gpg-agent"
        ln -sf "$sock" "$gpgdir/S.gpg-agent"
    end
    
    # Verify connection
    sleep 0.5  # Brief wait for socket initialization
    if gpg-connect-agent -S "$sock" "getinfo version" /bye >/dev/null 2>&1
        echo "GPG agent relay started (PID: $socat_pid)"
        return 0
    else
        echo "Relay started but verification failed" >&2
        return 1
    end
end