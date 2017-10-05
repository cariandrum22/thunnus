function thunnus.path.normalize -d "Normalize PATH"
  set acc
  for v in $argv
    set acc $acc (string trim -r -c '/' $v)
  end
end
