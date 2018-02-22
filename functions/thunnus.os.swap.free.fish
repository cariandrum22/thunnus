function thunnus.os.swap.free -d "Return the free space of swap"
  set -l free_swap

  switch (thunnus.os.platform.detect)
    case macOS
      set free_swap (sysctl vm.swapusage | awk '{ print $10 }')
    case Linux
      set free_swap (free -m | tail -n 1 | awk '{print $4}')'M'
    case '*'
      echo 'Could not detect the free space of swap.'
      return 1
  end

  echo $free_swap'B'
end
