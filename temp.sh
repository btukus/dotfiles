systemtype=$(uname -s)

if [[ "$systemtype" == "Darwin" ]]; then
  echo $systemtype
else
  echo "Not working" 
fi
