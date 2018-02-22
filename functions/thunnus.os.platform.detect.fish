function thunnus.os.platform.detect -d "Return platform"
  if [ (uname) = 'Darwin' ]
    echo 'macOS'
  else if [ string sub -s 1 -l 5 (uname -s) = 'Linux' ]
    echo 'Linux'
# I do not use cygwin, so I will probably not support it.
# else if [ string sub -s -l 10 (uname -s) = 'MINGW32_NT' ]
#   echo 'Cygwin'
  else
    echo 'Your platform '(uname -a)' is not supported.'
    return 1
  end
end
