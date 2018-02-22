function thunnus.os.memory.total -d "Return the total space of memory"
  set -l total_memory

  switch (thunnus.os.platform.detect)
    case macOS
      set total_memory (sysctl hw.memsize | awk '{ print $2 }')
    case Linux
      set total_memory (math (cat /proc/meminfo | grep 'MemTotal' | awk '{ print $2 }')" * 1024")
    case '*'
      echo 'Could not detect the total space of memory.'
      return 1
  end

  echo (math -s3 $total_memory "/ 1073741824")'GB'
end
