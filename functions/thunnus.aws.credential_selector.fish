function thunnus.aws.credential_selector -d "Export environment variables by specifying section from aws credential."
  set -l section $argv[1]
  set -l flag $argv[2]

  if [ -s $HOME/.aws/credentials ]
    set -l params (
      string split ' ' \
        (thunnus.file.ini.get_params_from_section "$HOME/.aws/credentials" $section)
    )

    for param in $params
      set -l kv (string split '=' $param)
      set -gx (echo $kv[1] | tr "[:lower:]" "[:upper:]") $kv[2]
    end

    set -gx AWS_DEAFULT_PROFILE "$section"

    if [ $flag = "tf" ]
      set -gx TF_VAR_access_key $AWS_ACCESS_KEY_ID
      set -gx TF_VAR_secret_key $AWS_SECRET_ACCESS_KEY
    end

  else
    echo "can't open input file: $HOME/.aws/credentials"
  end
end
