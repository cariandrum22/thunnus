function thunnus.os.memory.free -d "Return the free space of memory"

  set -l free_memory
  switch (thunnus.os.platform.detect)
    case macOS
      set free_memory (math (vm_stat | awk 'NR==2 { print $3 }')"* 4096 ")
    case Linux
      set free_memory (math (free -b | awk 'NR==2 { print $4 }')" / 1048576")
    case '*'
      echo 'Could not detect the free space of memory.'
      return 1
  end

  echo (math $free_memory "/ 1048576")'MB'

end
