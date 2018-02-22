function thunnus.os.load_average -d "Return load average"
  set -l load_average

  switch (thunnus.os.platform.detect)
    case macOS
      set load_average (sysctl -n vm.loadavg | awk '{ print $2 ", " $3 ", " $4 }')
    case Linux
      set load_average (cat /proc/loadavg | awk '{ print $1 ", " $2 ", " $3 }')
    case '*'
      echo 'Could not detect load average.'
      return 1
  end

  echo $load_average
end
