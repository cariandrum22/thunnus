function thunnus.path.concat -d "Add to the head of PATH"
  set -x PATH $argv $PATH
end