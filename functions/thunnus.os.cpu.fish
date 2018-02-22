function thunnus.os.cpu -d "Return the CPU model name"
  set -l model_name
  switch (thunnus.os.platform.detect)
    case macOS
      set model_name (sysctl -n machdep.cpu.brand_string)
    case Linux
      set model_name (cat /proc/cpuinfo | grep 'model name' | head -n 1 | cut -d':' -f2)
    case '*'
      echo 'Could not detect CPU model.'
      return 1
  end

  echo (string trim $model_name)
end
