function thunnus.os.detect -d "Detect Operating System"
  if [ (uname) = 'Darwin' ]
    echo 'macOS'
  else if [ string sub -s 1 -l 5 (uname -s) = 'Linux' ]
    echo 'Linux'
  else if [ string sub -s -l 10 (uname -s) = 'MINGW32_NT' ]
    echo 'Cygwin'
  else
    echo "Your platform ((uname -a)) is not supported."
    exit 1
  end
end
