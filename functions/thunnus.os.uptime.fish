function thunnus.os.uptime -d "Return the OS uptime"
  set -l argc (count $argv)

  function __call__
    set -l argc (count $argv)

    set -l boot
    switch (thunnus.os.platform.detect)
      case macOS
        set boot (string trim -r -c ',' (sysctl kern.boottime | awk '{ print $5}'))
      case Linux
        set boot (cat /proc/uptime | awk '{print $1}')
      case '*'
        echo 'Could not detect the OS uptime.'
        return 1
    end

    set -l uptime (math (date +%s) - $boot)

    set -l uptime_days    (math "$uptime % 31556926 / 86400")
    set -l uptime_hours   (math "$uptime % 31556926 % 86400 / 3600")
    set -l uptime_minutes (math "$uptime % 31556926 % 86400 % 3600 / 60")

    if [ $argc -lt 1 ]
      echo "$uptime_days days, $uptime_hours hours, $uptime_minutes minutes"
    else
      switch $argv[1]
        case d 'day*'
          echo "$uptime_days"
        case h 'hour*'
          echo "$uptime_hours"
        case m 'min'
          echo "$uptime_minutes"
        case '*'
          echo "Wrong augiment"
          return 1
      end
    end

    functions -e __call__
  end

  if [ $argc -lt 2 ]
    __call__ $argv
  else
    echo "Wrong number of arguments ($argc for 1)"
    return 1
  end
end
