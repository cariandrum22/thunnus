function fish_greeting
  status --is-login
  if [ $status = 0 ]
    if which fortune cowsay > /dev/null
      fortune | cowsay -f (cowsay -l | tail -n +2 | tr ' ' '\n' | gshuf -n1)
    end
  end
end
