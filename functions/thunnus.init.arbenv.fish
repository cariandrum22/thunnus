function thunnus.init.arbenv -d "Initialize the *env such as rbenv, ndenv, etc."
  for v in $argv
    thunnus.path.concat "$HOME/.$v/bin"
    eval "$v init - | source"
  end
end