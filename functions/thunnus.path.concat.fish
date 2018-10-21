function thunnus.path.concat -d "Add to the head of PATH"
  if [ -e $argv ]
    set -x PATH $argv $PATH
  end
end
