function thunnus.os.distro -d "Return distribution."
  set -l distro

  switch (thunnus.os.platform.detect)
    case macOS
      set distro (string trim (system_profiler SPSoftwareDataType | grep 'System Version' | cut -d':' -f2))
    case Linux
      set distro (thunnus.os.distro.detect)
    case '*'
      echo 'Could not detect distribution.'
      return 1
  end

  echo $distro
end
