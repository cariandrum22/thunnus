function arbenv -d "Set arbitrary environment"
  for v in $argv
    set_path "$HOME/.$v/bin"
    eval "$v init - | source"
  end
end