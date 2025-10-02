# Reset to commit SHA

function greset() {
  if [ -z "$1" ]; then
    echo "Please provide a commit SHA"
    return 1
  fi

  if [ -z "$2" ]; then
    echo "Please provide branch name"
    return 1
  fi

  commit=$1
  branch=$2

  git reset --hard $commit

  git push origin $branch --force
}
