function thunnus.file.ini.get_params_from_section -d "Get space separated parameters form section specified by argument."
  set -l ini_file_path $argv[1]
  set -l section $argv[2]

  set -l form "\1=\2"

  echo (
    sed -n -e "/^\[$section\]/,/^\s*\[/{/^[^;].*\ .*/p;}" < $ini_file_path \
      | sed -e 's/[[:space:]]*\=[[:space:]]*/ /g' \
            -e 's/[;#].*$//' \
            -e 's/[[:space:]]*$//' \
            -e 's/^[[:space:]]*//' \
            -e "s/^\(.*\)[[:space:]]\([^\"']*\)\$/$form/"
    )
end
