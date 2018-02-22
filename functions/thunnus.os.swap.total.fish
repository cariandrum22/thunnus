function thunnus.os.swap.total -d "Return the total space of swap"
  set -l total_swap

  switch (thunnus.os.platform.detect)
    case macOS
      set total_swap (sysctl vm.swapusage | awk '{ print $4}')
    case Linux
      set total_swap (math (cat /proc/meminfo | grep 'SwapTotal' | awk '{ print $2 }')" / 1024")
    case '*'
      echo 'Could not detect the total space of swap.'
      return 1
  end

  echo $total_swap'MB'
end
