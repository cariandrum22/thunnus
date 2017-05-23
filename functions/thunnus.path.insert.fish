function thunnus.path.insert -d "Add arguments to the head of PATH"
  set -x PATH $argv $PATH
end