# Git functions

# Print the repo's main branch (origin/HEAD, else main/master/trunk if present, else main)
git_main_branch() {
  emulate -L zsh
  local ref
  ref=$(git symbolic-ref -q --short refs/remotes/origin/HEAD 2>/dev/null) && { print -r -- ${ref#origin/}; return }
  for ref in main master trunk; do
    git show-ref -q --verify refs/heads/$ref || git show-ref -q --verify refs/remotes/origin/$ref && { print -r -- $ref; return }
  done
  print main
}

# Git commit and push
gcp() {
  if [[ -z "$1" ]]; then
    echo "Usage: gcp <commit message>"
    return 1
  fi
  git add --all
  if git commit -m "$1"; then
    git push
  else
    echo "Commit failed, not pushing"
    return 1
  fi
}

# Git update worktrees
gu() {
  source "$HOME/dotfiles/zsh/scripts/update-git-worktrees.zsh"
}

# Print the directory new worktrees belong in for the current repo:
#   bare layout (gbare) -> <repo>/wt   (`worktrees` is git's own metadata dir there)
#   normal clone        -> the repo's parent, i.e. a sibling of the checkout, so
#                          branches are never nested inside the main working tree
git_worktree_dir() {
  emulate -L zsh
  local common
  common=$(git rev-parse --path-format=absolute --git-common-dir 2>/dev/null) || return 1
  if [[ $(git -C $common rev-parse --is-bare-repository) == true ]]; then
    print -r -- $common/wt
  else
    print -r -- ${common:h:h}
  fi
}

# Add a worktree for <branch> (creates the branch from [base] or the main branch
# when it doesn't exist locally or on origin), then cd into it.
# Bare layout (gbare): <repo>/wt/<branch>; normal clone: sibling dir ../<branch>.
gwa() {
  emulate -L zsh
  local br=${1:?usage: gwa <branch> [base]} base=$2 root dest
  root=$(git_worktree_dir) || { print -u2 'not a git repository'; return 1 }
  dest=$root/$br
  mkdir -p $root || return 1
  git fetch -q origin 2>/dev/null || print -u2 "gwa: fetch failed, using local refs"
  if git show-ref -q --verify refs/heads/$br || git show-ref -q --verify refs/remotes/origin/$br; then
    git worktree add $dest $br || return 1
    git show-ref -q --verify refs/remotes/origin/$br && git -C $dest branch -q -u origin/$br
  else
    git worktree add -b $br $dest ${base:-origin/$(git_main_branch)} || return 1
    git -C $dest branch -q --unset-upstream 2>/dev/null   # new branch: `git push -u` sets its upstream
  fi
  cd $dest
}

# Same as gwa, but pulls the current branch first and forks a brand-new branch
# from where you are now rather than from the main branch.
gwag() {
  emulate -L zsh
  local br=${1:?usage: gwag <branch>} root dest
  root=$(git_worktree_dir) || { print -u2 'not a git repository'; return 1 }
  dest=$root/$br
  git pull --ff-only || print -u2 "gwag: pull failed, continuing with the refs you have"
  mkdir -p $root || return 1
  if git show-ref -q --verify refs/heads/$br; then
    git worktree add $dest $br || return 1
    git show-ref -q --verify refs/remotes/origin/$br && git -C $dest branch -q -u origin/$br
  elif git show-ref -q --verify refs/remotes/origin/$br; then
    git worktree add --track -b $br $dest origin/$br || return 1
  else
    git worktree add -b $br $dest HEAD || return 1
    git -C $dest branch -q --unset-upstream 2>/dev/null   # new branch: `git push -u` sets its upstream
  fi
  cd $dest
}

# Delete the current linked worktree and its branch, then cd to the base worktree
# (dev/develop/main/master) and pull it. Never touches the main worktree.
gwd() {
  emulate -L zsh
  local wt br common root base
  wt=$(git rev-parse --show-toplevel 2>/dev/null) || { print -u2 'not in a git worktree'; return 1 }
  common=$(git rev-parse --path-format=absolute --git-common-dir)
  [[ $(git rev-parse --path-format=absolute --git-dir) == $common ]] && { print -u2 'this is the main worktree, refusing'; return 1 }
  br=$(git branch --show-current)
  [[ -n $br ]] || { print -u2 'detached HEAD; aborting'; return 1 }
  [[ $br == (dev|develop|main|master|$(git_main_branch)) ]] && { print -u2 "refusing to delete base branch '$br'"; return 1 }

  if [[ $(git -C $common rev-parse --is-bare-repository) == true ]]; then root=$common; else root=${common:h}; fi
  cd $root || return 1
  if ! git worktree remove --force $wt; then
    print -u2 "worktree remove failed (locked? files in use by a dev server?) - nothing deleted"
    cd $wt; return 1
  fi

  for base in dev develop main master; do
    git show-ref -q --verify refs/heads/$base || continue
    local d=$(git worktree list --porcelain | awk -v b="branch refs/heads/$base" '/^worktree /{w=substr($0,10)} $0==b{print w; exit}')
    [[ -n $d ]] && { cd $d; git pull --ff-only || print -u2 "gwd: pull on '$base' failed; continuing"; }
    break
  done
  git branch -D $br && print "Deleted worktree and branch '$br'."
}

# Find merge conflict files
gfm() {
  git ls-files -u | awk '{print $4}' | sort | uniq
}

# Go to git root
git_root_cd() {
  local dir
  dir=$(git rev-parse --show-toplevel 2>/dev/null)
  if [ -n "$dir" ]; then
    cd "$dir" || return 1
    return 0
  else
    echo "Not a git repository"
    return 1
  fi
}

ghd() {
  git_root_cd
}

ghdd() {
  if git_root_cd; then
    cd ../ || return 1
  fi
}

# Merge origin's dev/develop into the current branch
gmd() {
  emulate -L zsh
  local base
  for base in dev develop; do
    git show-ref -q --verify refs/remotes/origin/$base && break
    base=
  done
  [[ -n $base ]] || { print -u2 'no dev/develop branch on origin'; return 1 }
  git fetch -q origin $base && git merge origin/$base
}

# On dev/develop: rebase onto origin's main branch, then (after confirming) force-push it
grmd() {
  emulate -L zsh
  local br main
  br=$(git branch --show-current)
  [[ $br == (dev|develop) ]] || { print -u2 "grmd: on '$br', expected dev or develop"; return 1 }
  main=$(git_main_branch)
  git fetch -q origin || return 1
  git rebase origin/$main || { print -u2 "Rebase failed. Resolve conflicts and run 'git rebase --continue'"; return 1 }
  read -q "?Force-push $br to origin? [y/N] " || { print; print 'Push cancelled'; return 1 }
  print
  git push --force-with-lease origin HEAD:$br
}

# Clone <url> as a bare repo with a worktree per base branch (main/master, dev, develop),
# each tracking origin. Ends in dev if it exists, else the main branch.
gbare() {
  emulate -L zsh
  local url=$1 name br
  [[ -n $url ]] || { print -u2 'usage: gbare <url> [dir]'; return 1 }
  name=${2:-${${url:t}%.git}}
  git clone --bare $url $name || return 1
  cd $name || return 1
  git config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
  git fetch -q origin || return 1
  git remote set-head origin -a >/dev/null
  mkdir -p wt || return 1
  for br in main master dev develop; do
    git show-ref -q --verify refs/heads/$br || continue
    git worktree add -q wt/$br $br && git -C wt/$br branch -q -u origin/$br
  done
  for br in dev develop main master; do [[ -d wt/$br ]] && { cd wt/$br; return }; done
}

# Hard-reset the current branch to <sha> and force-push it (with lease).
# The optional 2nd arg must match the current branch; it's a guard, not a target.
greset() {
  emulate -L zsh
  local sha=${1:?usage: greset <commit-sha> [branch]} br
  br=$(git branch --show-current)
  [[ -n $br ]] || { print -u2 'detached HEAD'; return 1 }
  [[ -z $2 || $2 == $br ]] || { print -u2 "greset: you're on '$br', not '$2' - switch branches first"; return 1 }
  git rev-parse -q --verify "$sha^{commit}" >/dev/null || { print -u2 "no such commit: $sha"; return 1 }
  read -q "?Reset '$br' to $sha and force-push to origin? [y/N] " || { print; print 'Reset cancelled'; return 1 }
  print
  git reset --hard $sha && git push --force-with-lease origin HEAD:$br
}

# Git remote fetch fix
gref() {
  git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
  git fetch
}
